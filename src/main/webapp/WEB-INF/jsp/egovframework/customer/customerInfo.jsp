<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://uicdn.toast.com/tui-grid/latest/tui-grid.css" />

<link rel="stylesheet" href="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.css" />
<script src="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.js"></script>
   
<link rel="stylesheet" href="https://uicdn.toast.com/tui.pagination/latest/tui-pagination.css" />
<script type="text/javascript" src="https://uicdn.toast.com/tui.pagination/v3.4.0/tui-pagination.js"></script>

<script src="https://uicdn.toast.com/tui-grid/latest/tui-grid.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.js"></script>

<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" />
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<link rel="stylesheet" href="https://uicdn.toast.com/grid/latest/tui-grid.css" />

<script src="https://code.jquery.com/ui/1.13.0/jquery-ui.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css">

<script src="https://uicdn.toast.com/grid/latest/tui-grid.js"></script>
</head>
<body>
	<div id="help" align="right" style="width : 1500px ;"><button type="button" id="helpBtn" style="border : none; background-color : #f2f7ff; color : #007b88; float : right ;"><i class="bi bi-question-circle"></i></button></div>
	<br>
	<div id="title" style="margin-left : 10px;"><h3 style="color : #054148; font-weight : bold">고객 관리</h3></div>	
	<div id="top" style="height : 110px; padding : 10px;">
		<span style="margin : 20px;">고객명</span><input id="txtCusName" style="margin-top : 10px; background-color: #d2e5eb;" readonly> 
		<span style="margin : 20px;">고객코드</span><input id="txtCusCode">&nbsp;<button type="button" id="btnSearch" style="border : none; background-color : #f8f8ff; color : #007b88;"><i class="bi bi-search"></i></button>		
		<br>
		<button type="button" id="clearBtn" class="btn" style="float : right; margin : 5px;">초기화</button>
		<button type="button" id="btnInsert" class="btn" style="float : right; margin : 5px;">저장</button>
		<button type="button" id="btnDelete" class="btn" style="float : right; margin : 5px;">삭제</button>
		<button type="button" id="btnAdd" class="btn" style="float : right; margin : 5px;">추가</button>
		<button type="button" id="listBtn" class="btn" style="float : right; margin : 5px;">조회</button>
	</div>
	
	<div id="OverallSize" style="margin-left : 10px;">
		<div id="info"></div>
	</div>
	
	<div id="findCustomer" title="고객검색"">
		<input id="cusName">&nbsp;<button id="btnCusSearch" class="btn">검색</button>
		<div id="cusResult"></div>
	</div>
	
	<div id="tradeInfo-dialog-form" title="거래처정보수정 / 거래내역조회" style="text-align: center;">
		<h5>거래처정보수정</h5>
		<br>
		<div id="cusInfo"></div>
		<br>
		<h5>거래내역조회</h5>
		<div id="tradeResult" style="height: 200px;"></div>
	</div>
	
	<div id="helpDialog" title="도움말"">
		<br>
		고객명 : 고객코드를 검색해서 검색결과를 선택하면 자동으로 입력됩니다.<br><br>
		고객코드검색 : 검색어를 포함한 고객명으로 고객코드를 검색합니다.<br><br>
		조회 : 조건 없이 조회하면 전체목록을 조회합니다.<br><br>
		추가 : <br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;업체코드 : 구매고객/판매고객을 선택하면 저장시 자동으로 입력됩니다.<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고객구분 : 업체코드를 선택 시 자동으로 입력됩니다.<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;모든 값을 다 입력해야 저장이 가능합니다.<br><br>
		초기화 : 입력한 조회 조건을 초기화합니다.
	</div>
<script>
	//---------- ↓페이지 ----------
	var Grid = tui.Grid ;
	
	const columns = [
		{
			header: '업체코드' ,
			name: 'cusCode' ,
			editor: {
				type : 'select' ,
				options: {
					listItems: [
						{ text: '제품 구매 고객' , value: '제품 구매 고객'} ,
						{ text: '자재 판매 고객' , value: '자재 판매 고객'}
					]
				}
			} ,
			align: 'center',
		    sortable: true,
		    sortingType: 'desc'
		} ,
		{
			header : '고객구분' ,
			name : 'cusType' ,
			editor : 'text' ,
			align: 'center'
			
		} ,
		{
			header: '업체명' ,
			name: 'codeName' ,
			editor: 'text' ,
			align: 'center',
		    sortable: true,
		    sortingType: 'desc'
		} ,
		{
			header: '연락처' ,
			name : 'cusPhone' ,
			editor: 'text' ,
			align: 'center'
		}
	] ;
	
	let data ;
	
	$('#listBtn').click(function () {
		let cusCode = $("#txtCusCode").val() ;
		
		if (cusCode == '') {
			cusCode = 'null' ;
		}
		
		$.ajax({
			url : 'customerList/' + cusCode ,
			dataType : 'json' ,
			async : false ,
			success : function(datas) {
				data = datas.data ;
				grid.resetData(data) ;
				grid.resetOriginData() ;
				
			} ,
			error : function(reject) {
				console.log(reject) ;
			}
		}) 
	})
	
	const grid = new Grid ({
		el : document.getElementById('info') ,
		rowHeaders: [
			{ type : 'rowNum' } ,
			{ type : 'checkbox'}
		] ,
		data : data ,
		columns ,
		bodyHeight : 430 ,
 		pageOptions: {
		    useClient: true,
		    perPage: 10
		} 
	}) ;
	
	$("#btnAdd").on("click" , function() {
		grid.appendRow({}) ;
	})
	
	grid.on('editingFinish' , (ev) => {
		let code = ev.value ;
		
		if(ev.columnName == 'cusCode') {
			if(code == '제품 구매 고객') {
				grid.setValue(ev.rowKey , 'cusType' , '판매처') ;
			} else {
				grid.setValue(ev.rowKey , 'cusType' , '구매처') ;
			}
		}
	})
	
	$("#btnInsert").on("click" , function() {
		grid.blur() ;
		
		let insertDatas = grid.getModifiedRows() ;
		let insertData = insertDatas.createdRows ;
		let insertCode = insertData[0].cusCode ;
		let insertName = insertData[0].codeName ;
		let insertPhone = insertData[0].cusPhone ;
		let codeDesct ;
		
		if (insertCode == null || insertName == null || insertPhone == null) {
			alert('입력값을 확인하세요') ;
			return ;
		}
		
		if (insertCode == '제품 구매 고객') {
			insertCode = 'b_' ;
			codeDesct = '판매처' ;
		} else {
			insertCode = 'm_' ;
			codeDesct = '구매처' ;
		}
		
		$.ajax({
			url : 'customerInsert' ,
			data : {
				cusCode : insertCode ,
				codeName : insertName ,
				cusPhone : insertPhone ,
				codeDesct : codeDesct
			} ,
			async : false ,
			success : function(datas) {
				alert('저장완료되었습니다') ;
				
				let cusCode = 'null' ;
				
				$.ajax({
					url : 'customerList/' + cusCode ,
					dataType : 'json' ,
					async : false ,
					success : function(datas) {
						data = datas.data ;
						grid.resetData(data) ;
						grid.resetOriginData() ;
					} ,
					error : function(reject) {
						console.log(reject) ;
					}
				})
			} ,
			error : function(reject) {
				console.log(reject) ;
			}
		})
	})
	
	var rowCodes = new Array() ;
	
	grid.on('check' , (ev) => {
		rowCodes[ev.rowKey] = data[ev.rowKey].cusCode ;
	})
	
	grid.on('uncheck' , (ev) => {
		delete rowCodes[ev.rowKey] ;
	})
	
	$("#btnDelete").on("click" , function() {
		console.log(rowCodes) ;
		let ok = 1 ;
		for (let i = 0 ; i < rowCodes.length ; i++) {
			if (rowCodes[i] != null) {
				let cusCode = rowCodes[i] ;
				
				$.ajax({
					url : 'deleteCustomer/' + cusCode ,
					async : false ,
					success : function(datas) {						
						ok = 2 ;
						
						let cusCode = 'null' ;
						
						$.ajax({
							url : 'customerList/' + cusCode ,
							dataType : 'json' ,
							async : false ,
							success : function(datas) {
								data = datas.data ;
								grid.resetData(data) ;
								grid.resetOriginData() ;
							} ,
							error : function(reject) {
								console.log(reject) ;
							}
						})
					} , 
					error : function(reject) {
						console.log(reject) ;
					}
				})
				delete rowCodes[i] ;
			}
		}
		if (ok == 2) {
			alert('삭제완료되었습니다') ;
		}
	})
	
	$("#clearBtn").on("click" , function() {
		$("#txtCusCode").val("") ;
		$("#txtCusName").val("") ;
	})
	//---------- ↑페이지 ----------
	
	//---------- ↓업체찾기 ----------
	let dialog = $("#findCustomer").dialog({
		autoOpen : false ,
		modal : true ,
		width : 600 ,
		height : 600 ,
		buttons: {
			"닫기" : function() {
				dialog.dialog("close") ;
				grid2.clear() ;
				$("#cusName").val("") ;
			}
		},
	})
	
	$("#btnSearch").on("click" , function() {
		dialog.dialog("open") ;
		$.ajax({
			url : 'findCustomerAll' ,
			dataType : 'json' ,
			async : false ,
			success : function(datas) {
				data2 = datas.customerall ;
				grid2.resetData(data2) ;
				grid2.resetOriginData() ;
			} ,
			error : function(reject) {
				console.log(reject) ;
			}
		})		
		grid2.refreshLayout() ;
	})
	
	const columns2 = [
		{
			header: '업체코드' ,
			name: 'cusCode' ,
			align: 'center'
		} ,
		{
			header: '업체명' ,
			name: 'codeName' ,
			align: 'center'
		}
	] ;
	
	let data2 ;
	
	$("#btnCusSearch").on("click" , function() {
		var codeName = $("#cusName").val() ;
		
		if (codeName == '') {
			alert('업체명을 입력하세요') ;
			return ;
		}
		
		$.ajax({
			url : 'findCustomer/' + codeName ,
			dataType : 'json' ,
			async : false ,
			success : function(datas) {
				data2 = datas.customer ;
				grid2.resetData(data2) ;
				grid2.resetOriginData() ;
			} ,
			error : function(reject) {
				console.log(reject) ;
			}
		})
	})
	
	const grid2 = new Grid({
		el : document.getElementById('cusResult') ,
		rowHeaders: [
			{ type : 'rowNum' }
		] ,
		bodyHeight : 300 ,
		data : data2 ,
		columns : columns2 ,
 		pageOptions: {
		    useClient: true,
		    perPage: 10
		} 
	})
	
	grid2.on('click',(ev) => {
		let cusCode = data2[ev.rowKey].cusCode ;
		let cusName = data2[ev.rowKey].codeName ;
		$("#txtCusCode").val(cusCode) ;
		$("#txtCusName").val(cusName) ;
		grid2.clear() ;
		dialog.dialog("close") ;
		$("#cusName").val("") ;
	})
	//---------- ↑업체찾기 ----------
	
	//---------- ↓상세정보 ----------
	let dialog2 = $("#tradeInfo-dialog-form").dialog({
		autoOpen : false ,
		modal : true ,
		width : 600 ,
		height : 660 ,
		buttons : {
			"저장" : function() {
				grid4.blur() ;
				
				let datas = grid4.getModifiedRows() ;
				let data = datas.updatedRows ;
				let cusCode = data[0].cusCode ;
				let codeName = data[0].codeName ;
				let cusPhone = data[0].cusPhone ;
				
				$.ajax({
					url : 'updateCustomer' ,
					data : {
						cusCode : cusCode ,
						codeName : codeName ,
						cusPhone : cusPhone
					} ,
					dataType : 'json' ,
					contentType : 'application/json ; charset=utf-8;' , 
					async : false ,
					success : function(datas) {
						alert('수정완료되었습니다.') ;
						data4 = datas.update ;
						grid4.resetData(data4) ;
						grid4.resetOriginData() ;
					} ,
					error : function(reject) {
						console.log(reject) ;
					}
				})
			} ,
			"닫기" : function() {
				dialog2.dialog("close") ;
				
				let cusCode = $("#txtCusCode").val() ;
				
				if (cusCode == '') {
					cusCode = 'null' ;
				}
				
				$.ajax({
					url : 'customerList/' + cusCode ,
					dataType : 'json' ,
					async : false ,
					success : function(datas) {
						data = datas.data ;
						grid.resetData(data) ;
						grid.resetOriginData() ;
						
					} ,
					error : function(reject) {
						console.log(reject) ;
					}
				})
			}
		}
	})
	
	const columns3 = [
		{
			header: '주문코드' ,
			name: 'ordCode' ,
			align: 'center' ,
			width : 90
		} ,
		{
			header: '제품코드' ,
			name: 'podtCode' ,
			align: 'center' ,
			width : 70
		} ,
		{
			header: '제품명' ,
			name: 'podtName' ,
			width: 200 ,
			align: 'center'
		} ,
		{
			header: '주문일' ,
			name: 'ordDate' ,
			align: 'center' ,
			width : 90
		} ,
		{
			header: '주문량' ,
			name: 'ordQnt' ,
			align: 'center' ,
			formatter(value) {
				return value.value.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",") ;
			}
		}
	] ;
	
	let data3 ;

	const columns4 = [
		{
			header: '업체명' ,
			name: 'codeName' ,
			editor: 'text' ,
			align: 'center'
		} ,
		{
			header: '연락처' ,
			name: 'cusPhone' ,
			editor: 'text' , 
			align: 'center'
		}
	] ;
	
	let data4 ;
	
	grid.on('click',(ev) => {
		
		if (ev.columnName === '_checked'){
			return ev.stop() ;
		}
		
		let cusCode = data[ev.rowKey].cusCode ;
		
		dialog2.dialog("open") ;
		grid3.refreshLayout() ;
		grid4.refreshLayout() ;
		
 		$.ajax({
			url : 'selectTradeInfo/' + cusCode ,
			dataType : 'json' ,
			async : false ,
			success : function(datas) {
				data3 = datas.trade ;
				grid3.resetData(data3) ;
				grid3.resetOriginData() ;
			} ,
			error : function(reject) {
				console.log(reject) ;
			}
		}).done( function() {
 			$.ajax({
 				url : 'customerList/' + cusCode ,
 				dataType : 'json' ,
 				async : false ,
 				success : function(datas) {
 					data4 = datas.data ;
 					grid4.resetData(data4) ;
 					grid4.resetOriginData() ;
 					
 				} ,
 				error : function(reject) {
 					console.log(reject) ;
 				}
 			}) 
 		})
	})
	
	const grid3 = new Grid({
		el : document.getElementById('tradeResult') ,
		rowHeaders: [
			{ type : 'rowNum' }
		] ,
		data : data3 ,
		columns : columns3 ,
		bodyHeight : 220 ,
 		pageOptions: {
		    useClient: true,
		    perPage: 5
		} 
	})
	
	const grid4 = new Grid({
		el : document.getElementById('cusInfo') ,
		rowHeaders: [
			{ type : 'rowNum' }
		] ,
		data : data4 ,
		columns : columns4 ,
		bodyHeight: 60,
		minBodyHeight: 60
	})
	
	let dialog3 = $("#helpDialog").dialog({
		autoOpen : false ,
		modal : true ,
		width : 600 ,
		height : 400 ,
		buttons: {
			"닫기" : function() {
				dialog3.dialog("close") ;
			}
		},
	})
	
	$("#helpBtn").on("mouseover" , function() {
		dialog3.dialog("open") ;
	}) ;
	//---------- ↑상세정보 ----------
</script>
</body>
</html>