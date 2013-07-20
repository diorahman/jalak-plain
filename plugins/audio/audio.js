(function(){

  if(!Jalak.plugins){ Jalak.plugins = {};}

  Jalak.plugins["audio"] = function(){
    function update(data){
      document.getElementById("volume").innerText = data;
    }

    return { update : update};
  }

})()
