/*
 * jalak - webkit-javascriptcore playground
 *
 * Copyright (c) 2013, Dhi Aurrahman <dio@rockybars.com>
 * All rights reserved. Released under the MIT license.
 */

namespace Jalak{

  namespace App{

    internal void init(void * ctx, Jalak.Page p){
      var bridge = new Bridge(ctx, p);
      var app = new JS.App(bridge, new Jalak.Plugins(bridge), "App");

      // load plugins from config
      // app.loadFromConfig(config);
    }
  }
}