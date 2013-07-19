/*
 * jalak - webkit-javascriptcore playground
 *
 * Copyright (c) 2013, Dhi Aurrahman <dio@rockybars.com>
 * All rights reserved. Released under the MIT license.
 */

namespace Jalak{

  public class Page : WebKit.WebView {

    public Page(){
      var settings = new WebKit.WebSettings();
      settings.enable_file_access_from_file_uris = true;
      settings.enable_universal_access_from_file_uris = true;
      set_settings(settings);

      window_object_cleared.connect(this.on_window_object_cleared);
    }

    private void on_window_object_cleared(WebKit.WebFrame frame, void * context){
      App.init(context, this);
    }

    public void load(){
      load_uri ("file://" + Environment.get_current_dir() + "/public/index.html");
    }
  }
}