<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://uicdn.toast.com/tui-grid/latest/tui-grid.css" />
<link rel="stylesheet" href="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.css" />
<link rel="stylesheet" href="//code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
<script src="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.js"></script>
<script src="https://uicdn.toast.com/tui-grid/latest/tui-grid.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.js"></script>
<script src="https://code.jquery.com/ui/1.13.0/jquery-ui.js"></script>
</head>
<body>
	<h2>재고조회</h2>
<div id="tabs">
  <ul>
    <li><a href="#tabs-1">안전 재고</a></li>
    <li><a href="#tabs-2">LOT별 재고</a></li>
  </ul>
  
  <div id="tabs-1">	
	<hr>
	자재코드  <input id="txtRsc1">  <button id="btnFindRsc">돋보기</button>  자재명 <input id="txtRsc2" readonly><br>
	<hr>
	<div id="dialog-form-rsc" title="자재 검색"></div>
	<br>
	<button id="btnSelect">조회</button>
	<button id="btn_reset" type="reset">초기화</button>
	<button>엑셀</button>
	<hr>	
	<div id="gridRsc1"></div>
	<hr>
	</div>
	
	
	<div id="tabs-2">
	<hr>
	자재코드  <input id="txtRscLot1">  <button id="btnFindRscLot">돋보기</button>  자재명 <input id="txtRscLot2" readonly><br>
	<hr>
	<div id="dialog-form-rsc-Lot" title="자재 검색"></div>
	<br>
	<button id="btnSelectLot">조회</button>
	<button id="btn_reset_Lot" type="reset">초기화</button>
	<button>엑셀</button>
	<hr>
	<div id="gridRscLot"></div>
	</div>
</div>	

<script type="text/javascript">

$( function() {
    $( "#tabs" ).tabs();
  } );
  
  
//////////////////////////////////////////////안전재고조회////////////////////////////////////////////////	

	//초기화 버튼
	$("#btn_reset").on("click", function(){
		$("#txtRsc1").val('');
		$("#txtRsc2").val('');
	})
	
	//모달창(자재조회)
	function clickRsc(rscCode, rscName){
		$("#txtRsc1").val(rscCode);
		$("#txtRsc2").val(rscName);
		dialog2.dialog("close");
	};
	
	let dialog2 = $( "#dialog-form-rsc" ).dialog({
		autoOpen: false,
		modal: true,
		heigth : 500,
		width : 900,
	});
	
	$("#btnFindRsc").on("click", function(){
		dialog2.dialog("open");
	$("#dialog-form-rsc").load("recList2",
			function(){console.log("로드됨")})
	});
	
	//그리드 
	var Grid = tui.Grid;
	Grid.applyTheme('default');
	
	const columns = [
			  {
			    header: '자재코드',
			    name: 'rscCode',
			    sortable: true,
			    sortingType: 'desc'
			  },
			  {
				header: '자재명',
				name: 'rscName',
			    sortable: true,
			    sortingType: 'desc'
			  },
			  {
				header: '단위',
				name: 'rscUnit'
			   },
			  {
				header: '입고량',
				name: 'istCnt'
			   },
				{
				  header: '출고량',
				  name: 'ostCnt'
				},
				{
				  header: '재고',
				  name: 'rscCnt'
				},
				{
				  header: '안전재고',
				  name: ''
				}
			];
	
	//ajax(api)로 값 받아오는 거 
	let dataSource = {
		  api: {
		    readData: { 
		    	url: 'resourceStoreInventory', 
		    	method: 'GET'
		    	}
		  },

		  contentType: 'application/json'
		};
	
	const grid = new Grid({
		  el: document.getElementById('gridRsc1'),
		  data: null,
		  columns
		});
	
	//조회버튼 클릭시 값 가지고 오는 거
	$("#btnSelect").on("click", function(){
			var rscCode = $("#txtRsc1").val();
			
			$.ajax({
				url :'resourceStoreInventory',
				data: {'rscCode' : rscCode },
				contentType: 'application/json; charset=UTF-8'
			}).done(function(da){
				var datalist = JSON.parse(da);
				console.log(datalist);
				grid.resetData(datalist["data"]["contents"]);
			})
					
		})
		
//////////////////////////////////////////////자재 LOT별 재고////////////////////////////////////////////////		
	
	//초기화 버튼
	$("#btn_reset_Lot").on("click", function(){
		$("#txtRscLot1").val('');
		$("#txtRscLot2").val('');
	})
	
	//모달창(자재조회)
	function clickRsc(rscCode, rscName){
		$("#txtRscLot1").val(rscCode);
		$("#txtRscLot2").val(rscName);
		dialogLot.dialog("close");
	};
	
	let dialogLot = $( "#dialog-form-rsc-Lot" ).dialog({
		autoOpen: false,
		modal: true,
		heigth : 500,
		width : 900,
	});
	
	$("#btnFindRscLot").on("click", function(){
		dialogLot.dialog("open");
	$("#dialog-form-rsc-Lot").load("recList2",
			function(){console.log("로드됨")})
	});
	
	//그리드 
	var Grid = tui.Grid;
	Grid.applyTheme('default');
	
	const columnsLot = [
			  {
			    header: '자재코드',
			    name: 'rscCode',
			    sortable: true,
			    sortingType: 'desc'
			  },
			  {
				header: '자재명',
				name: 'rscName',
			    sortable: true,
			    sortingType: 'desc'
			  },
			  {
			    header: '자재 LOT',
				name: 'rscLot',
				sortable: true,
				sortingType: 'desc'
				},
			  {
				header: '단위',
				name: 'rscUnit'
			   },
			  {
				header: '입고량',
				name: 'istCnt'
			   },
				{
				  header: '출고량',
				  name: 'ostCnt'
				},
				{
				  header: '재고',
				  name: 'rscCnt'
				},
			];
	
	//ajax(api)로 값 받아오는 거 
	let dataSourceLot = {
		  api: {
		    readData: { 
		    	url: 'resourceStoreInventory', 
		    	method: 'GET'
		    	}
		  },

		  contentType: 'application/json'
		};
	
	const gridRscLot = new Grid({
		  el: document.getElementById('gridRscLot'),
		  data: null,
		  columns : columnsLot
		});
	
	//조회버튼 클릭시 값 가지고 오는 거
	$("#btnSelectLot").on("click", function(){
			var rscCode = $("#txtRscLot1").val();
			
			$.ajax({
				url :'resourceStoreInventory',
				data: {'rscCode' : rscCode },
				contentType: 'application/json; charset=UTF-8'
			}).done(function(da){
				var datalist = JSON.parse(da);
				console.log(datalist);
				gridRscLot.resetData(datalist["data"]["contents"]);
			})
					
		})

</script>
</body>
</html>