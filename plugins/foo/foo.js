

(function(){
  if(!Jalak.plugins){ Jalak.plugins = {}; }

  Jalak.plugins["foo"] = function(){


    function update(){
      console.log('update')
    }

    function draw(){
      console.log('draw')
    }

    return {
      update : update,
      draw : draw
    };
  }

})()



