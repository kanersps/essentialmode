const updateUser = (identifier, newData) => {
    for(key in newData){
        emit("es_sqlite:updateUserData", identifier, key, newData[key])
    }


}

on("es_sqlite:updateUser", updateUser)