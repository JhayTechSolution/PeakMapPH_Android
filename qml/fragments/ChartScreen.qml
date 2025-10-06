import QtQuick 2.15

Charts{

    enum ChartType{
        Line,
        Bar,
        HorizontalBar
    }
    property int chartStyle: ChartScreen.ChartType.Line
    property int labelXRotation: 0
    property int labelYRotation: 0
    property bool hasLabelY: true
    property bool hasLabelX: true
    property bool hasGridY: false
    property bool hasGridX: false
    property string xLabelColor:"#d8d8d8"
    property string yLabelColor:"#d8d8d8"
    function hexToRgbaArray(hex) {
      hex = hex.replace(/^#/, '');
    
      // Handle shorthand (#RGB or #ARGB)
      if (hex.length === 3) {
        hex = hex.split('').map(c => c + c).join('');
      } else if (hex.length === 4) {
        hex = hex.split('').map(c => c + c).join('');
      }
    
      let r, g, b, a;
    
      if (hex.length === 8) {
        // AARRGGBB
        a = parseInt(hex.slice(0, 2), 16) / 255;
        r = parseInt(hex.slice(2, 4), 16);
        g = parseInt(hex.slice(4, 6), 16);
        b = parseInt(hex.slice(6, 8), 16);
      } else if (hex.length === 6) {
        // RRGGBB
        a = 1;
        r = parseInt(hex.slice(0, 2), 16);
        g = parseInt(hex.slice(2, 4), 16);
        b = parseInt(hex.slice(4, 6), 16);
      } else {
        throw new Error("Invalid hex color: " + hex);
      }
    
      return [r, g, b, a];
    }
    
    property string gridLinesColor:"#000000"
    property string dataBackgroundColor:"#000000"
    property string dataBorderColor:"#000000"
    property list<string> pieBackgroundColors: []
    property var chartLabels : []
    property var dataSets: []
    onDataSetsChanged: {
        Component.completed()
    }
    
    anchors.fill: parent 
    chartType:  (function(){

        if(root.chartStyle === ChartScreen.ChartType.Bar ){
            return 'bar'
        }else if(root.chartStyle === ChartScreen.ChartType.HorizontalBar){
            return 'horizontalBar'
        }

        return 'line'
    })()
    id: root 
    chartData: { return {
                labels: root.chartLabels,
                datasets: root.realDataSet
        }
    }
    property var realDataSet: []
    Component.onCompleted: {
        Qt.callLater(()=>{
            var rds = []
            for(var i=0; i < root.dataSets.length; i++){
                 rds.push({

                    fill: true,
                    backgroundColor: "rgba(%1)".arg(hexToRgbaArray(root.dataBackgroundColor).join(',')),
                    borderColor: "rgba(%1)".arg(hexToRgbaArray(root.dataBorderColor).join(',')),
                    data: root.dataSets[i],
                    pointRadius:0
                })
            }
            root.realDataSet=[]
            root.realDataSet= rds
        })
    }


    chartOptions: {
        return {
            maintainAspectRatio: false,
            responsive:true ,
            legend:{
                display:false
            },

            scales: {
                xAxes:[{
                    display: root.hasLabelX,
                    gridLines:{
                        display: root.hasGridX,
                        color:"rgba(%1)".arg(hexToRgbaArray(root.gridLinesColor).join(','))
                    },
                    ticks:{
                        fontColor: xLabelColor,
                        maxRotation: labelXRotation,
                        minRotation: labelXRotation
                    }

                }],
                yAxes:[{
                    display: root.hasLabelY,
                    gridLines: {
                        display: root.hasGridY,
                        color:"rgba(%1)".arg(hexToRgbaArray(root.gridLinesColor).join(','))
                    },
                    ticks:{
                        fontColor: yLabelColor,
                        maxRotation: labelYRotation,
                        minRotation: labelYRotation
                    }
                }]

            },
            legend:{
                display:false
            }
        }
    }

}
