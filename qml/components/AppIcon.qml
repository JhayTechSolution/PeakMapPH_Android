import QtQuick 2.15
import Qt5Compat.GraphicalEffects
Item{
    id: ctl
    property string iconType
    onIconTypeChanged: {
        if(!iconType){
            return
        }
        if(iconType == ""){
            return
        }

        img.source = iconType
    }

    property int size
    width: ctl.size
    height: ctl.size
    property string color
    clip:true
    Image{
      id: img
      width: parent.width
      height: parent.height
      layer.enabled: true
      layer.effect: ColorOverlay{
          color: ctl.color
      }
      anchors.centerIn: parent
    }
}
