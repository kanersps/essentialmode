const sql = require("./server/sqlite/sql.js");
const fs = require("fs");

const databaseFile = "./essentialmode.db"
let canExecute = false
let readying = false

// :(

let db

const checkDatabase = (cb) => {
    console.log("[EssentialMode] Performing DB check...")
    readying = true
    fs.readFile(databaseFile, (err, data) => {
        if(!data){
            console.log("\n[EssentialMode] No database found, creating...\n")
            db = new sql.Database();
            db.exec("CREATE TABLE players (identifier STRING, license STRING, `group` STRING, bank INTEGER, money INTEGER, permission_level INTEGER, roles STRING)")
            
            fs.writeFile(databaseFile, db.export(), (err) => {
                if(err)
                    console.log(err);
                if(cb)
                    cb();
            })
        } else {
            db = new sql.Database(data);
            console.log("\n[EssentialMode] Database loaded!\n")
            if(cb)
                cb()
        }
    })
}

const saveDatabase = (cb) => {
    if(!canExecute)
        return;
    fs.writeFile(databaseFile, db.export(), (err) => {
        if(err)
            console.log(err);
        if(cb)
            cb();
    })
}

const updateUser = (identifier, newData, cb) => {
    let query = "UPDATE players SET ";

    let loops = 0;
    for(key in newData){
        if((Object.keys(newData).length - 1) == loops)
            query += `\`${key}\`='${newData[key]}' `
        else
            query += `\`${key}\`='${newData[key]}',`

        loops += 1;
    }
    
    query += `WHERE identifier='${identifier}'`

    db.run(query);

    if(cb)
        cb()
}

const createUser = (identifier, license, cash, bank, gr, pl, roles, callback) => {
    console.log("[EssentialMode] createUser called")
    let query = `INSERT INTO players (identifier, license, money, bank, \`group\`, permission_level, roles) VALUES ('${identifier}', '${license}', ${cash}, ${bank}, '${gr}', ${pl}, '${roles}')`;

    if(canExecute){
        db.run(query);
        saveDatabase();
        callback();
    }else{
        console.log("[EssentialMode] Database not ready yet! (Recalling in 5 seconds)")
        if(!readying)
            checkDatabase(() => {
                canExecute = true
            });
        setTimeout(() => {
            createUser(identifier, license, cash, bank, gr, pl, roles, callback);
        }, 5000)
    }
}

const doesUserExist = (identifier, callback) => {
    if(canExecute){
        const result = db.exec(`SELECT * from players WHERE identifier='${identifier}'`)

        if(result[0])
            callback(result[0].values[0] != undefined)
        else
            callback(false)
    }else{
        console.log("[EssentialMode] Database not ready yet! (Recalling in 5 seconds)")
        if(!readying)
            checkDatabase(() => {
                canExecute = true
            });
        setTimeout(() => {
            doesUserExist(identifier, callback);
        }, 5000)
    }
}

const retrieveUser = (identifier, callback) => {
    const result = db.exec(`SELECT * from players WHERE identifier='${identifier}'`)
    let buildedUser = {};

    for(key in result[0].columns){
        buildedUser[result[0].columns[key]] = result[0].values[0][key];
    }

    callback(JSON.stringify(buildedUser), true)
}

on("es_sqlite:initialize", () => {
    checkDatabase(() => {
        canExecute = true
    });
})

on("es_sqlite:createUser", createUser)
on("es_sqlite:updateUser", updateUser)
on("es_sqlite:doesUserExist", doesUserExist)
on("es_sqlite:retrieveUser", retrieveUser)

// Save database every 60 seconds or manually by event
setInterval(saveDatabase, 60000)
on("es_sqlite:save", saveDatabase)