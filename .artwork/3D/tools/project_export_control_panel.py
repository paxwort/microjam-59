bl_info = {
    "name": "Project Export Control Panel",
    "blender": (5, 0, 0),
    "category": "Collection",
}

import bpy
from bpy.props import StringProperty
from bpy.props import BoolProperty

class ProjectExportControlPanel(bpy.types.Panel):
    """Creates a Panel in the Collection properties window"""
    bl_label = "Exporter Control Panel"
    bl_idname = "COLLECTION_PT_Project_Export_Control_Panel"
    bl_space_type = 'PROPERTIES'
    bl_region_type = 'WINDOW'
    bl_context = "collection"
    
    def draw(self, context):
        layout = self.layout

        obj = context.object
        row = layout.row()        
        row.prop(context.scene, "project_output_dir")
        
        row = layout.row()
        row.prop(context.scene, "project_texture_dir")
        
        row = layout.row()
        row.prop(context.collection, "is_proxy_subdir")
        
        row = layout.row()
        row.operator("collection.project_export_config_op")


class ProjectExportConfigOperator(bpy.types.Operator):
    bl_idname = "collection.project_export_config_op"
    bl_label = "Configure gltf separate exporter"

    def get_collection_path(self, target_collection, root=None):
        if root is None:
            root = bpy.context.scene.collection
        def search(coll, path):
            path = path + [coll]
            if coll == target_collection:
                return path
            for child in coll.children:
                result = search(child, path)
                if result is not None:
                    return result
            return None
        
        return search(root, [])

    exporter_name = "To Godot"
    
    def execute(self, context):
        #get path
        coll = context.collection
        scene = context.scene
        path = scene.project_output_dir + "models/"
        texture_path = "../" + scene.project_texture_dir
        for p in self.get_collection_path(coll):
            if p != coll and p.is_proxy_subdir:
                path += p.name + "/"
                texture_path ="../" + texture_path
        path += coll.name + ".gltf"
        
        #check for existing exporter
        exporter = next((e for e in coll.exporters if e.name == self.exporter_name), None)
        if exporter is None:
            exporter = coll.exporters.new(type="IO_FH_gltf2", name = self.exporter_name)
        exporter.filepath = path
        props = exporter.export_properties
        props.export_format='GLTF_SEPARATE'
        props.export_texture_dir = texture_path
#        for p in dir(props):
#           self.report({"INFO"}, p)
        return {'FINISHED'}



def register():
    bpy.types.Scene.project_output_dir =StringProperty(name="Project output directory",
                                            subtype="DIR_PATH",
                                            options={'PATH_SUPPORTS_BLEND_RELATIVE'},
                                            default="//")
    bpy.types.Scene.project_texture_dir =StringProperty(name="Texture directory name",
                                            default="textures")
    bpy.types.Collection.is_proxy_subdir = BoolProperty(name="Treat this collection as a subdirectory",
                                            default=False)

    bpy.utils.register_class(ProjectExportControlPanel)
    bpy.utils.register_class(ProjectExportConfigOperator)


def unregister():
    bpy.utils.unregister_class(ProjectExportControlPanel)
    bpy.utils.unregister_class(ProjectExportConfigOperator)
    del bpy.types.Scene.project_output_dir
    del bpy.types.Scene.project_texture_dir
    del bpy.types.Collection.is_proxy_subdir 

if __name__ == "__main__":
    register()

