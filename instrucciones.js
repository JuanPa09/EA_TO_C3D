
var variables = "abcdefghijklmnopqrstuvwxyz";
var acumulador = "";
var ultimoTmp = "";
var index = 0;



const instruccionesApi = {

    newTemp:function(){
        if(index == 26){
            acumulador = ultimoTmp;
            index = 0;
        }
        ultimoTmp = acumulador + variables[index];
        index++;
        return ultimoTmp
    }
    

}

module.exports.instruccionesApi = instruccionesApi;