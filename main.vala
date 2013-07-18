/*
 * jalak - webkit-javascriptcore playground
 *
 * Copyright (c) 2013, Dhi Aurrahman <dio@rockybars.com>
 * All rights reserved. Released under the MIT license.
 */

namespace Jalak{

  int main(string[] args){

    Gtk.init (ref args);

    var window = new Gtk.Window ();
      var page = new Page();

      window.add(page);
      window.show_all();

      page.load();

      window.destroy.connect(Gtk.main_quit);
      Gtk.main ();
    
    return 0;
  }
}
