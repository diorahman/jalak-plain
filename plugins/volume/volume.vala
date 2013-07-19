/*
 * jalak - plugin app poc
 *
 * Copyright (c) 2013, Dhi Aurrahman <dio@rockybars.com>
 * All rights reserved. Released under the MIT license.
 */

public class Core : Peas.ExtensionBase, Jalak.Plugin{

    private Jalak.Bridge bridge;
    private PulseGlue glue;

    public void init(void * ctx){
        bridge = (Jalak.Bridge) ctx;
        glue = new PulseGlue(this);
        glue.start();
        Jalak.Util.inject_plugin_script(bridge.page, get_plugin_info());
    }

    public void destroy(){
        stdout.printf("core destroy \n");
    }
        
    public void update(string data){
        Jalak.Util.inject_script(bridge.page, "Jalak.plugins[\"volume\"]().update(" + data + ")");
    }

    public void draw(string data){
        stdout.printf("core destroy \n");
    }

    public bool exec(string data){
        stdout.printf("try to set \n");
        glue.pulse_glue_sync_volume(int.parse(data));
        return false;
    }

    public string get_info(){
        return "{ \"volume\" : 24 }";
    }
 }

[ModuleInit]
public void peas_register_types(GLib.TypeModule module)
{
    var objmodule = module as Peas.ObjectModule;
    objmodule.register_extension_type(typeof (Jalak.Plugin), typeof (Core));
}