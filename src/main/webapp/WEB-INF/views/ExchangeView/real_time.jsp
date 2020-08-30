<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>

<html>
<head>

    <title>환율 조회 시스템</title>
	<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
    <link class="include" rel="stylesheet" type="text/css" href="/resources/graph_res/css/jquery.jqplot.min.css" />
    <link rel="stylesheet" type="text/css" href="/resources/graph_res/css/examples.min.css" />
    <link class="include" type="text/css" href="/resources/graph_res/css/jquery-ui.css" rel="Stylesheet" /> 
    <script class="include" type="text/javascript" src="/resources/graph_res/js/jquery.min.js"></script>
	<script class="include" type="text/javascript" src="/resources/graph_res/js/jquery.jqplot.min.js"></script>
</head>
<body>
<header>
	<h1 class="logo">실시간 환율 조회 시스템</h1>
	<nav class="navi">
		<ul>
			<li><a href="currencies_view">환율변동조회</a></li>		
		</ul>
	</nav>
</header>
<div class="section">
<section>
    <div class="chart-container">    
        <div id="chart1"></div>
    </div>

  <style type="text/css">
*{padding:0;margin:0}
.logo{padding:40px 0; text-align:center; color:#c85179; background-color:#fdeff2}
.navi{padding:10px 0; overflow:hidden;background-color:#e198b4}
.navi ul, li{padding:0 10px; float:left; list-style:none}
a{padding:20px; text-decoration:none; color:#fff}

.section{color:#e198b4}
.title{text-align:center;padding:20px}
.content{margin:0}
.content table{margin:0 auto; width:400}
.content table th,td{text-align:center; color:#e198b4;border:1px solid #c85179}
.btn_group{text-align:center;}

.footer{padding:20px;background-color:#fdeff2}
.footer p{text-align:center;color:#c85179}


    .chart-container {
        border: 1px solid darkblue;
        padding: 30px 0px 30px 30px;
        width: 900px;
        height: 400px;
        
    }

    table.jqplot-table-legend {
        font-size: 0.65em;
        line-height: 1em;
        margin: 0px 0px 10px 15px;
    }

    td.jqplot-table-legend-label {
      width: 20em;
    }

    div.jqplot-table-legend-swatch {
        border-width: 1.5px 6px;
    }

    div.jqplot-table-legend-swatch-outline {
        border: none;
    }

    #chart1 {
        width: 96%;
        height: 96%;
    }

    .jqplot-datestamp {
      font-size: 0.8em;
      color: #777;
/*      margin-top: 1em;
      text-align: right;*/
      font-style: italic;
      position: absolute;
      bottom: 15px;
      right: 15px;
    }

  </style>

<script class="code" type="text/javascript">
var wsUri = "wss://creativeegg.duckdns.org:54321/ws";
var output;


function init()
{
  output = document.getElementById("output");
  testWebSocket();
}

function testWebSocket()
{
  websocket = new WebSocket(wsUri);
  websocket.onopen = function(evt) { onOpen(evt) };
  websocket.onclose = function(evt) { onClose(evt) };
  websocket.onmessage = function(evt) { onMessage(evt) };
  websocket.onerror = function(evt) { onError(evt) };
}

function onOpen(evt)
{
}

function onClose(evt)
{
}

function onMessage(evt)
{
	var data = JSON.parse(evt.data);

	
}

function onError(evt)
{
  writeToScreen('<span style="color: red;">ERROR:</span> ' + evt.data);
}

function doSend(message)
{
  writeToScreen("SENT: " + message);
  websocket.send(message);
}

function writeToScreen(message)
{
  var pre = document.createElement("p");
  pre.style.wordWrap = "break-word";
  pre.innerHTML = message;
  output.appendChild(pre);
}

window.addEventListener("load", init, false);






/* 실시간 */
$(document).ready(function(){	
var t = 1000;
var n = 20;
var x = (new Date()).getTime(); // current time
var data = [];
for(i=0; i<n; i++){
	data.push([x - (n-1-i)*t,0]);
} 

var options = {
    axes: {
  	   xaxis: {
  	   	  numberTicks: 4,
          renderer:$.jqplot.DateAxisRenderer,
          tickOptions:{formatString:'%H:%M:%S'},
          min : data[0][0],
          max: data[data.length-1][0]
	   },
	   yaxis: {min:0, max: 1,numberTicks: 6,
  	        tickOptions:{formatString:'%.1f'} 
	   }
    },
    seriesDefaults: {
  	   rendererOptions: { smooth: true}
    },
    legend: {
        show: true,
        renderer: $.jqplot.EnhancedLegendRenderer,
        placement: "outsideGrid",
        location: "ne",
        rowSpacing: "0px",
        rendererOptions: {
           seriesToggle: 'normal',
           seriesToggleReplot: {
              resetAxes: true
           }
        }
     },
};
var plot1 = $.jqplot ('chart1', [data],options);


$('button').click( function(){  
    doUpdate();
    $(this).hide();
});

function doUpdate() {

    if(data.length > n-1){
    	data.shift();
    }

    var y = Math.random();
    var x = (new Date()).getTime();

    data.push([x,y]);
    if (plot1) {
    	plot1.destroy();
    }
    plot1.series[0].data = data; 
    options.axes.xaxis.min = data[0][0];
    options.axes.xaxis.max = data[data.length-1][0];
    plot1 = $.jqplot ('chart1', [data],options);
    setTimeout(doUpdate, t);
}

});
 
 
 
 
</script>
	<button>Start Updates</button>
  <div id="output"></div>

<script class="include" type="text/javascript" src="/resources/graph_res/js/jquery.jqplot.min.js"></script>
<script class="include" type="text/javascript" src="/resources/graph_res/js/jquery-ui.min.js"></script>
<script class="include" type="text/javascript" src="/resources/graph_res/js/jqplot.canvasAxisTickRenderer.js"></script>
<script class="include" type="text/javascript" src="/resources/graph_res/js/jqplot.canvasAxisLabelRenderer.js"></script>
<script type="text/javascript" src="/resources/graph_res/js/jqplot.logAxisRenderer.js"></script>
<script type="text/javascript" src="/resources/graph_res/js/jqplot.canvasTextRenderer.js"></script>
<script type="text/javascript" src="/resources/graph_res/js/jqplot.canvasAxisLabelRenderer.js"></script>
<script type="text/javascript" src="/resources/graph_res/js/jqplot.canvasAxisTickRenderer.js"></script>
<script type="text/javascript" src="/resources/graph_res/js/jqplot.dateAxisRenderer.js"></script>
<script type="text/javascript" src="/resources/graph_res/js/jqplot.categoryAxisRenderer.js"></script>
<script type="text/javascript" src="/resources/graph_res/js/jqplot.barRenderer.js"></script>
<script type="text/javascript" src="/resources/graph_res/js/jqplot.cursor.js"></script>


</section>
</div>
<br><br>
<div class="footer">
<footer>
	<p>Seolhwa Copyright@2020 All rights reserve</p>
</footer>
</div>


</body>


</html>