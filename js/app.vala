/*
 * jalak - webkit-javascriptcore playground
 *
 * Copyright (c) 2013, Dhi Aurrahman <dio@rockybars.com>
 * All rights reserved. Released under the MIT license.
 */

namespace Jalak{

    namespace JS{

        public class App : GLib.Object{

            public void * context { get; set; }
            
            private static Jalak.Bridge bridge { get; set; }
            private static Jalak.Plugins plugins { get; set; }

            public App(Bridge b, Jalak.Plugins p, string name){
                bridge = b;
                context = b.context;
                plugins = p;
                setup(name);

                bridge.test.connect(() => { print("hurrah"); } );
            }

            public static JSCore.Object class_constructor(JSCore.Context ctx, JSCore.Object constructor,  JSCore.Value[] arguments, out JSCore.Value exception) 
            {
                var c = new JSCore.Class (class_definition);
                var o = new JSCore.Object (ctx, c, null);

                /*
                    Do something with object
                */

                return o;
            }

            static const JSCore.StaticFunction[] class_functions = {
                { "hello", function_hello, JSCore.PropertyAttribute.ReadOnly },
                { "loadPlugin", function_loadPlugin, JSCore.PropertyAttribute.ReadOnly },
                { "unloadPlugin", function_unloadPlugin, JSCore.PropertyAttribute.ReadOnly },
                { "getPluginInfo", function_getPluginInfo, JSCore.PropertyAttribute.ReadOnly },
                { "exec", function_exec, JSCore.PropertyAttribute.ReadOnly },
                { null, null, 0 }
            };

            private static bool load_plugin(string name){
                return plugins.load(name);
            }

            private static bool unload_plugin(string name){
                return plugins.unload(name);
            }

            private static string get_plugin_info(string name){
                return plugins.get_info(name);
            }

            private static bool exec(string name, string data){
                return plugins.exec(name, data);
            }

            public static JSCore.Value function_loadPlugin (JSCore.Context ctx,
                JSCore.Object function,
                JSCore.Object thisObject,
                JSCore.Value[] arguments,
                out JSCore.Value exception) 
            {
                stdout.printf("plugin loading \n");

                // args[0] -> { name : foo} -- options
                // args[1] -> function(err, retObj){} -- callback

                var name = Jalak.Util.string_property_from_value(ctx, arguments[0], "name");
                var callback = Jalak.Util.string_from_js_string(arguments[1].to_string_copy (ctx, null));

                // read .js -> put in string -> populate

                // poc
                // var pluginObj = 
                
                var args = "null, {status : 'ok', name: '" + name + "' }";

                if(!load_plugin(name)){ 
                    args = "new Error('plugin loading failed'), {status : 'fail', name: '" + name + "' }";
                }

                Jalak.Util.evaluate_callback(ctx, callback, args);

                return new JSCore.Value.undefined (ctx);
            }

            public static JSCore.Value function_unloadPlugin (JSCore.Context ctx,
                JSCore.Object function,
                JSCore.Object thisObject,
                JSCore.Value[] arguments,
                out JSCore.Value exception) 
            {
                stdout.printf("unload plugin \n");

                // args[0] -> { name : foo} -- options
                // args[1] -> function(err, retObj){} -- callback

                var name = Jalak.Util.string_property_from_value(ctx, arguments[0], "name");
                var callback = Jalak.Util.string_from_js_string(arguments[1].to_string_copy (ctx, null));
                var args = "null, {status : 'ok', name: '" + name + "' }";

                if(!unload_plugin(name)){ 
                    args = "new Error('plugin loading failed'), {status : 'fail', name: '" + name + "' }";
                }

                Jalak.Util.evaluate_callback(ctx, callback, args);

                return new JSCore.Value.undefined (ctx);
            }

            public static JSCore.Value function_getPluginInfo (JSCore.Context ctx,
                JSCore.Object function,
                JSCore.Object thisObject,
                JSCore.Value[] arguments,
                out JSCore.Value exception) 
            {

                // args[0] -> { name : foo} -- options
                // args[1] -> function(err, retObj){} -- callback

                var name = Jalak.Util.string_property_from_value(ctx, arguments[0], "name");
                var callback = Jalak.Util.string_from_js_string(arguments[1].to_string_copy (ctx, null));

                // read .js -> put in string -> populate

                // poc
                // var pluginObj = 
                
                var args = "null, {status : 'ok', info_str: " + get_plugin_info(name) + " }";
                Jalak.Util.evaluate_callback(ctx, callback, args);

                return new JSCore.Value.undefined (ctx);
            }

            public static JSCore.Value function_exec (JSCore.Context ctx,
                JSCore.Object function,
                JSCore.Object thisObject,
                JSCore.Value[] arguments,
                out JSCore.Value exception) 
            {

                // args[0] -> { name : foo} -- options
                // args[1] -> function(err, retObj){} -- callback

                var name = Jalak.Util.string_property_from_value(ctx, arguments[0], "name");
                var data = Jalak.Util.string_property_from_value(ctx, arguments[0], "data");
                var callback = Jalak.Util.string_from_js_string(arguments[1].to_string_copy (ctx, null));

                // read .js -> put in string -> populate

                // poc
                // var pluginObj = 

                var args = "null, {status : 'ok', status: true }";

                if(!exec(name, data))
                    args = "new Error('exec failed'), {status : 'fail', name: '" + name + "' }";
                
                Jalak.Util.evaluate_callback(ctx, callback, args);

                return new JSCore.Value.undefined (ctx);
            }

            public static JSCore.Value function_hello (JSCore.Context ctx,
                JSCore.Object function,
                JSCore.Object thisObject,
                JSCore.Value[] arguments,
                out JSCore.Value exception) 
            {
                //bridge.test();
                return new JSCore.Value.undefined (ctx);
            }

            private void setup(string class_name){
                var str = new JSCore.String.with_utf8_c_string (class_name);
                var class = new JSCore.Class (class_definition);
                var obj = new JSCore.Object ((JSCore.GlobalContext) context, class, (JSCore.GlobalContext) context);
                var global_ctx = ((JSCore.GlobalContext) context).get_global_object ();
                global_ctx.set_property ((JSCore.GlobalContext) context, str, obj, JSCore.PropertyAttribute.None, null);
            }

            static const JSCore.ClassDefinition class_definition = {
            0,
            JSCore.ClassAttribute.None,
            "App",
            null,

            null,
            class_functions,

            null,
            null,

            null,
            null,
            null,
            null,

            null,
            null,
            class_constructor,
            null,
            null
            };
        }
    }
}