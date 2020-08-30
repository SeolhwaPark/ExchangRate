<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>

<html>
<head>

    <title>환율 조회 시스템</title>

    <link class="include" rel="stylesheet" type="text/css" href="/resources/graph_res/css/jquery.jqplot.min.css" />
    <link rel="stylesheet" type="text/css" href="/resources/graph_res/css/examples.min.css" />
    <link class="include" type="text/css" href="/resources/graph_res/css/jquery-ui.css" rel="Stylesheet" /> 
    <script class="include" type="text/javascript" src="/resources/graph_res/js/jquery.min.js"></script>
   	
</head>
<body onload="showClock()">
<header>
	<h1 class="logo">환율 조회 시스템</h1>
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
/* 유닉스 timestamp를 인간이 알 수 있는 시간형식으로 변환 */
function getTimestampToDate(timestamp) {
   var date = new Date(timestamp);
   var chgTimestamp = date.getFullYear().toString() + "-" + addZero(date.getMonth() + 1) + "-" + addZero(date.getDate().toString()) + " " + addZero(date.getHours().toString()) + ":" + addZero(date.getMinutes().toString()) + ":" + addZero(date.getSeconds().toString());
   return chgTimestamp;
}

function addZero(data) 
{
   return (data < 10) ? "0" + data : data;
}



/* ajax */
	var array_labels = new Array();
	var array_currencies = new Array();
	
	$.ajax({
	   url: "/ExchangeRate/rate?currency=${params}",
	   /* 데이터를 받아올 주소 */
	   type: "GET",
	   dataType: "json",
	   /* 파싱해서 오브젝트가 들어간다 */
	   success: function (r) 
	   {
	      var sum;
	      var cnt;
	      var ri;
	      var d;
	      var sr, psr;
	      
	      for (var j = 0; j < r.length; ++j)
	      {
	         array_currencies[j] = new Array();
	         
	         if (r[j].length)
	            array_labels[j] = r[j][0].currency;
	         
	         ri = psr = sr = sum = cnt = 0;

	         for (var i = 0; i < r[j].length; ++i) 
	         {
	            d = new Date(r[j][i].timestamp);
	            sr = d.getHours(); 
	            if (psr == 0) psr = sr;
	            sum += r[j][i].value;
	            ++cnt;
	            
	            if (psr != sr) 
	            {
	               array_currencies[j][ri++] = [d, sum / cnt];
	               sum = cnt = 0;
	               psr = sr;
	            }
	         }
	      }
	      
	      $.fn.draw_graph();
	   }
	});

	
	/*
$.ajax({
     url: "/ExchangeRate/rate?currency=${params}",// 데이터를 받아올 주소 
     type: "GET",
     dataType: "json",// 파싱해서 오브젝트가 들어간다 
     success: function (r) 
    
     {
       var sum, cnt, ri, sr, psr;// 총수 
       var d;
       //서버에서 받아온 날짜가 다음날로 바뀌면 카운트 
       // 날짜넣을 곳 
       // 조회중인 날의 일수 , 조회중인 날과 비교할 전 날의 일수 
       

       for(var j=0; j<r.length; ++j){
    	  array_currencies[j] = new Array();
    	   
    	   if(r[j].length){
    		   array_labels[j] = r[j][0].currency;
    		   
    	   }
    	   
    	   ri = psr = sr = sum = cnt = 0;
    	   
    	   for(var i = 0; i < r[j].length; ++i)
           	{
              d = new Date(r[j][i].timestamp);// 자바스크립트에서 쓸 수 있는 날짜로 변환 
              sr = d.getHours();// 조회할 날의 일수가 들어감 
             
              if (psr == 0)
                psr = sr;

              if (psr != sr)// 조회중인 날의 일수가 바뀔 때 
              {
                 array_currencies[j][ri++] = [d, sum / cnt];// 일일평균값 
                 sum = cnt = 0;
                 psr = sr;
              }
              
              sum += r[j][i].value;
              ++cnt;
          	 }
    	   
    	   
           if (psr == sr) //조회중인 날의 일수가  조회중인 날의 전날의 일수가 같을 때
              array_currencies[ri] = [d, sum / cnt];
       }
      
			$.fn.draw_graph();
		}
	});
	*/
	
/* chart */
$.fn.draw_graph = function () 
{
   var plot2 = $.jqplot('chart1', array_currencies, {
      title: "환율 변동",
      animate: true,
      axesDefaults: {
         labelRenderer: $.jqplot.CanvasAxisLabelRenderer
      },
      seriesDefaults: {
         showMarker: false
      },
      legend: {
         show: true,
         renderer: $.jqplot.EnhancedLegendRenderer,
         placement: "outsideGrid",
         labels: array_labels,
         location: "ne",
         rowSpacing: "0px",
         rendererOptions: {
            seriesToggle: 'normal',
            seriesToggleReplot: {
               resetAxes: true
            }
         }
      },
      axes: {
         xaxis: {
            renderer: $.jqplot.DateAxisRenderer,
            label: '년월일',
            labelRenderer: $.jqplot.CanvasAxisLabelRenderer,
            tickRenderer: $.jqplot.CanvasAxisTickRenderer,
            tickOptions: {
               formatString: '%y/%m/%d',
               angle: -45
            }
         },
         yaxis: {
            label: '달러기준($)',
            labelRenderer: $.jqplot.CanvasAxisLabelRenderer
         }
      },
       cursor:{ 
             show: true,
             zoom:true, 
             showTooltip:false
         } 
   });
   
   $.fn.captionParse();
   
   // add a date at the bottom.

   $("div.chart-container").resizable({
      delay: 20
   });
   $("div.chart-container").bind("resize", function (event, ui) {
      plot2.replot();
      $.fn.captionParse();
   });
};

$.fn.captionParse = function()
{
	   var as = $(".jqplot-table-legend-label");
	   
	   for (var i = 0; i < as.length; ++i)
		  as[i].setAttribute("currencies", as[i].innerHTML);
	  
};

/*
var time_different;

$.ajax({
	   url: "/ExchangeRate/time",
	   // 데이터를 받아올 주소 
	   type: "GET",
	   dataType: "json",
	   // 파싱해서 오브젝트가 들어간다 
	   success: function (r) 
	   {
		   time_different
	   }
});
	 
*/

/* 현재시간 */

	function beutifulTime(now)
	{
		return now.getFullYear() + "-" + (now.getMonth()+1) + "-" + now.getDate() + " " + now.getHours() + ":" + now.getMinutes() + ":" + now.getSeconds();
	}
	
   function today(){
           var clock = document.getElementById("clock");// 출력할 장소 선택
           var now;
			var cur;
			var ti = 0;
           var currencies = $(".jqplot-table-legend-label");
           
           for (var i = 0 ; i < currencies.length; ++i)
        	{
        	   now = new Date();// 현재시간
        	   cur = currencies[i].getAttribute("currencies");

        	   switch (cur)
        	   {
	        	   case "USD":
	        		   ti = -13;
	        		   break;
	        	   case "EUD":
	        		   ti = -10;
	        		   break;
	        	   case "CNY":
	        		   ti = -1;
	        		   break;
	        	   case "PHP":
	        		   ti = -10;
	        		   break;
	        	   case "JPY":
	        		   break;
        	   }
        	   
        	   now.setHours(ti + now.getHours());
        	   currencies[i].innerHTML = cur + " / " + beutifulTime(now);
        	}
           
           clock.innerHTML = beutifulTime(new Date());// 현재시간을 출력
           setTimeout("today()",1000);// setTimeout(“실행할함수”,시간) 시간은1초의 경우 1000
	}

	window.onload = function() {  // 페이지가 로딩되면 실행
           today();
	}
 
	
	
</script>
	<div>
		<th>현재 국내 시각 : </th>
		<div id="clock">
		</div>
		
	</div>


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