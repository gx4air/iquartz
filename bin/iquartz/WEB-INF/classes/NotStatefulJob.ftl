package com.tech.dawn.iquartz.job;

import com.tech.dawn.iquartz.exception.IqrtzException;
import com.tech.dawn.iquartz.plugin.Plugin;
import com.tech.dawn.iquartz.plugin.PluginResult;
import com.tech.dawn.iquartz.util.ExtJarLoader;
import com.tech.dawn.iquartz.util.PropUtil;
import java.io.File;
import java.net.URL;
import java.util.List;
import java.util.Map;

public class ${jobname} extends AbstractNotStatefulJob{
    @Override
    public boolean doExecute(Map<String, String> params) throws IqrtzException{
        try{

            String path = PropUtil.getValue("org.quartz.job.plugins.root") + File.separator + "plugins" + File.separator+"${pluginname}";

            ExtJarLoader loader = new ExtJarLoader(new URL[]{});
            System.out.println("loader--->"+loader);
            List<String> jars = getJarsList(path);

            for(String jar : jars){
            URL url  = new URL("jar:file:"+jar+"!/");
            System.out.println("jar--->"+"jar:file:/"+jar+"!/");
            loader.addJarFile(url);
            }

            Plugin p = (Plugin)loader.loadClass("${pluginpath}").newInstance();

            PluginResult pr = p.doPlug(params);

            loader.unloadJarFiles();
            loader = null;

            return pr.isResulst();

        }catch (Throwable e){
            throw new IqrtzException(e);
        }
    }
}