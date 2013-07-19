/*
 * jalak - webkit-javascriptcore playground
 *
 * Copyright (c) 2013, Dhi Aurrahman <dio@rockybars.com>
 * All rights reserved. Released under the MIT license.
 */


namespace Jalak{
  
  namespace Util{

    public string string_from_js_string(JSCore.String s){
      char[] buffer = new char[s.get_length() + 1]; 
      s.get_utf8_c_string (buffer, buffer.length); 
      var result = (string) buffer;
      buffer = null;
      return result;
    }

    public string string_property_from_value(JSCore.Context ctx, JSCore.Value val, string property_name){
      return string_from_js_string(val.to_object(ctx, null).get_property(ctx, new JSCore.String.with_utf8_c_string(property_name), null).to_string_copy(ctx, null));
    }

    public void evaluate_callback(JSCore.Context ctx, string callback, string args){
      // hackish for now!
      var script = new JSCore.String.with_utf8_c_string("(" + callback +  ")(" + args + ")");
      ctx.evaluate_script(script, null, null, 0, null);
    }

    public void inject_script(Jalak.Page page, string script){
      page.execute_script(script);
    }

    public bool inject_plugin_script(Jalak.Page page, Peas.PluginInfo info){
      var file = File.new_for_path(info.get_module_dir() + "/" + info.get_module_name() + ".js");
      if (!file.query_exists ()) {
        stderr.printf ("File '%s' doesn't exist.\n", file.get_path ());
        return false;
      }

      var script = "";

      try {
        var dis = new DataInputStream (file.read ());
        string line;
        while ((line = dis.read_line (null)) != null) {
            script += line;
        }

        Jalak.Util.inject_script(page, script);

      } catch (Error e) {
          error ("%s", e.message);
      }
      return true;  
    }


  }
  
}