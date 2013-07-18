/*
 * jalak - plugin app poc
 *
 * Copyright (c) 2013, Dhi Aurrahman <dio@rockybars.com>
 * All rights reserved. Released under the MIT license.
 */

public class Core : Peas.ExtensionBase, Jalak.Plugin{

    private Jalak.Bridge bridge;

    public void init(void * ctx){
        bridge = (Jalak.Bridge) ctx;
        stdout.printf("core init \n");

        // bridge.test.connect( () => {stdout.printf("test signal \n");});
        // build JavaScript object using bridge.context <-- this is the global context of the page

        Jalak.Util.evaluate_callback((JSCore.GlobalContext) bridge.context, "function(err, obj){ alert('hihi');}", "null, {}");
    }
        
    public void destroy(){
        stdout.printf("core destroy \n");
    }

 }

[ModuleInit]
public void peas_register_types(GLib.TypeModule module)
{
    var objmodule = module as Peas.ObjectModule;
    objmodule.register_extension_type(typeof (Jalak.Plugin), typeof (Core));
}