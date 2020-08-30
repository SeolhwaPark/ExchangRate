<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>환율 조회 시스템</title>
<script class="include" type="text/javascript" src="/resources/graph_res/js/jquery.min.js"></script>
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

</style>
<script type="text/javascript">

$.ajax({
    url: "/ExchangeRate/currencies",/* 데이터를 받아올 주소 */
    type: "GET",
    dataType: "json",/* 파싱해서 오브젝트가 들어간다 */
    success: function (r) 
    {
		var selectbox = document.getElementsByName("currencies")[0];
    	
    	for(var x=0; x<r.currencies.length; x++){
    		var op = new Option();
    	    op.value = r.currencies[x];
    	    op.text = r.currencies[x];
    	 
	    	selectbox.add(op);
    	}
    }
 });

function send() {
	if(rate.currencies.selectedIndex == 0){
		alert("통화가 선택되지 않았습니다.");		
		return false;
	}
	rate.submit();
	
}
function del() {
	history.back();
}

function real_submit() {
	location.href="real_time";
}
</script>
</head>
<body>


<div class="header">
<header>
	<h1 class="logo">환율 조회 시스템</h1>
	<nav class="navi">
		<ul>
			<li><a href="currencies_view">환율변동조회</a></li>		
		</ul>
	</nav>
</header>
</div>
<div class="section">
<section>
	<h2 class="title">국가별 환율 변동 조회</h2>
	<div class="content">
		<form name="rate" method="get" action="rate_chart">
			<table>
				<tr>
					<th>국가명</th>
					<td>
					<select name="currencies" multiple="multiple">
						<option>통화를 선택해주세요</option>
					</select>
					</td>
				</tr>
				<tr>
					<td	colspan="2" class="btn_group">
						<input type="button" value="조회하기" onClick="send()">
						<input type="button" value ="실시간 환율 정보" onclick ="real_submit()">
						<input type="button" value="취소하기" onClick="del()">
					</td>
				</tr>
			</table>
		</form>
	</div>
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
