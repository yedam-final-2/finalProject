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

<script src="https://uicdn.toast.com/tui.date-picker/latest/tui-date-picker.js"></script>
<script src="https://uicdn.toast.com/tui-grid/latest/tui-grid.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.0/jquery-ui.js"></script>
</head>
<body>
	<div id="title" align="center"><h2>제품 입/출고 관리</h2></div>
	<br>
	<div id="info">
		<span>제품코드 : </span><input id="txtPodtCode"><button type="button" id="btnSearch">제품코드검색</button>
		<br>
		<br>
		<span>작업일자 : </span><input id="manDatestart" type="date"><span> ~ </span><input id="manDateend" type="date">
		<br>
		<div align="right">
<!-- 테스트 -->
			<a href="ProductTestPage">테스트페이지</a>
<!-- 테스트 -->
			<button type="button" id="listBtn">조회</button>
			<button type="button" id="btnAdd">추가</button>
			<button type="button" id="btnInsert">저장</button>
			<button type="button" id="btnDelete">삭제</button>
			<button type="button" id="clearBtn">초기화</button>
		</div>
	</div>
	
	<div id="findProduct" title="제품코드검색">
		<input id="podtName"><button id="btnPodtSearch">검색</button>
		<div id="podtResult"></div>
	</div>
	
	<div id="qr" title="QR코드조회" align='center'>
		<input type="text" id="result" readonly>
		<br>
		<div id="qrTable"></div>
	</div>
	
<script>
	var Grid = tui.Grid ;
	
	//---------- ↓페이지 ----------
	let podtList = [] ;
	
	const columns = [
		{
			header: '번호' ,
			name: 'qntInfono' ,
			hidden: true
		} ,
		{
			header: '제품코드' ,
			name: 'podtCode' ,
			editor: {
				type: 'select' ,
				options: {
					listItems: podtList 
				}
			} ,
			align: 'center'
		} ,
		{
			header: '제품명' ,
			name: 'codeName' ,
			align: 'center'
		} ,
		{
			header: '작업일자' ,
			name : 'manDate' ,
			editor: 'datePicker' ,
			align: 'center'
		} ,
		{
			header: '입고량' ,
			name : 'podtInput' ,
			editor: 'text' ,
			align: 'center'
		} ,
		{
			header: '출고량' ,
			name : 'podtOutput' ,
			editor: 'text' ,
			align: 'center'
		} ,
		{
			header: '비고	' ,
			name : 'podtEtc' ,
			align: 'center' ,
			formatter : 'listItemText' ,
			editor: {
				type : 'select' ,
				options: {
					listItems: [
						{ text : '선택' , value: '' } ,
						{ text : '생산완료' , value: '생산완료' } ,
						{ text : '출하완료' , value: '출하완료' } ,
						{ text : '출하' , value: '출하' } ,
						{ text : '미생산출하' , value: '미생산출하' }
					]
				}
			} ,
			relations: [
				{
					targetNames: ['podtLot'] ,
					listItems({ value }) {
						return second[value] ;
					} ,
					disabled({ value }) {
						return !value ;
					}
				}
			]
		} ,
		{
			header: '생산지시코드' ,
			name : 'comCode' ,
			align : 'center'
		} ,
		{
			header: '완제품 Lot' ,
			name : 'podtLot' ,
			align: 'center' ,
			formatter: 'listItemText' ,
			editor: {
				type : 'select' ,
				options : {
					listItems : []
				}
			}
		}
	] ;
	
	let data ;
	
	$.ajax({
		url : 'selectPodtOptions' ,
		dataType : 'json' ,
		async : false ,
		success : function(datas) {
			for (let i = 0 ; i < datas.selectpodtoptions.length ; i++) {
				let option = { text : datas.selectpodtoptions[i].codeName , value : datas.selectpodtoptions[i].code } ;
				podtList.push(option) ;
			}
			
		} , 
		error : function(reject) {
			console.log(reject) ;
		}
	})
	
	$("#listBtn").click(function () {		
		let podtCode = $("#txtPodtCode").val() ;
		let manDatestart = $("#manDatestart").val() ;
		let manDateend = $("#manDateend").val() ;
		
		if (podtCode == '') {
			podtCode = 'null' ;
		}
		
		if (manDatestart == '') {
			manDatestart = '1910-12-25' ;
		}
		
		if (manDateend == '') {
			manDateend = '1910-12-25' ;
		}
		
		$.ajax({
			url : 'productList' ,
			dataType : 'json' ,
			data : {
				podtCode : podtCode ,
				manDatestart : manDatestart ,
				manDateend : manDateend
			} ,
			async : false ,
			success : function(datas) {
				data = datas.productlist ;
				grid.resetData(data) ;
				grid.resetOriginData() ;
						
				$.ajax({
					url : 'selectOptions' ,
					dataType : 'json' ,
					async : false ,
					success : function(datas) {
						
						// 조회 누를때마다 중복으로 안들어가도록 함
						second.생산완료 = [] ;
						second.출하 = [] ;
						second.미생산출하 = [] ;
						
						let lots = [] ;
						let lots2 = [] ;
						
						for (let a = 0 ; a < datas.selectoptions.length ; a++) {
							lots.push(datas.selectoptions[a].podtLot) ;
							let data = { podtLot : datas.selectoptions[a].podtLot , qnt : datas.selectoptions[a].qnt} ;
							lots2.push(data) ;	
						}


						// 중복제거
						let set1 = new Set(lots) ;
						let set2 = [...set1] ;
						
						// 중복제거한거 options로 넣음
						for (let b = 0 ; b < set2.length ; b++) {
							let options2 = { text : set2[b] , value : set2[b] } ;
							second.생산완료.push(options2) ;
							second.출하완료.push(options2) ;
						}
												
						for (let c = 0 ; c < lots2.length ; c++) {
							if (lots2[c].qnt > 0) {
								let options3 = { text : lots2[c].podtLot , value : lots2[c].podtLot } ;
								second.출하.push(options3) ;
								second.미생산출하.push(options3) ;	
							}
						}
						
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
	
	const grid = new Grid({
		el : document.getElementById('info') ,
		rowHeaders: [
			{ type : 'rowNum' } ,
			{ type : 'checkbox' }
		] ,
		height : 300 ,
		data : data , 
		columns : columns
	})
	
	const second = {
		'생산완료' : [
			{ text : '선택' , value : ''}
		] ,
		'출하완료' : [
			{ text : '선택' , value : ''}
		] ,
		'출하' : [
			{ text : '선택' , value : ''}
		] ,
		'미생산출하' : [
			{ text : '선택' , value : ''}
		]
	} ;	
	
	// 입력된 데이터 수정못하게 하기
	grid.on('editingStart' , (ev) => {
		let value = grid.getValue(ev.rowKey , ev.columnName) ;
		let lot = ev.columnName ;
		
		if (value != '' && value != null) {
			if (lot != 'podtLot' || value != null) {
				ev.stop() ;	
			}
		} 
	})
	
	$("#btnAdd").on("click" , function() {
		let data = { podtEtc : '출하' , podtInput : '0'} ;
		grid.appendRow(data) ;
	})
	
	$("#btnInsert").on("click" , function() {
		let insertDatas = grid.getModifiedRows() ;
		let insertData = insertDatas.createdRows ;
		
		let datas = grid.getModifiedRows() ;
		let data = datas.updatedRows ;
		
		 if (data != '') {
			
	  		let ok = 1 ;
			for (let i = 0 ; i < data.length ; i++) {
				
				let no = data[i].qntInfono ;
				let lot = data[i].podtLot ;
				let podtCode = data[i].podtCode ;
				let input = data[i].podtInput ;
				let output = data[i].podtOutput ;
				
	 			$.ajax({
					url : 'updateLotno' ,
					async : false ,
					data : {
						qntInfono : no ,
						podtLot : lot ,
						podtCode : podtCode ,
						podtInput : input ,
						podtOutput : output
					} ,
					success : function(datas) {
						ok = 2 ;
						
						podtCode = 'null' ;
						manDatestart = '1910-12-25' ;
						manDateend = '1910-12-25' ;
						
						$.ajax({
							url : 'productList' ,
							dataType : 'json' ,
							data : {
								podtCode : podtCode ,
								manDatestart : manDatestart ,
								manDateend : manDateend
							} ,
							async : false ,
							success : function(datas) {
								data = datas.productlist ;
								
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
			}  
			if (ok == 2) {
				alert('수정완료되었습니다') ;
			}
		}
		 
		if (insertData != '') {
			let change = insertData[0].podtEtc ;
			if (change == '출하') {
				insertData[0].podtEtc = '출하완료' ;
			}
			
			let ok = 1 ;
			for (let i = 0 ; i < insertData.length ; i++) {
				let insertCode = insertData[0].podtCode ;
				let insertDate = insertData[0].manDate ;
				let insertInput = insertData[0].podtInput ;
				let insertOutput = insertData[0].podtOutput ;
				let insertEtc = insertData[0].podtEtc ;
				let insertLot = insertData[0].podtLot ;
				
				if (insertCode == '' || insertDate == '' || insertInput == '' || insertOutput == '' || insertCode == '') {
					alert('입력값을 확인하세요') ;
					return ;
				}
				
				if (insertEtc == '') {
					insertEtc = 'null'
				}
				
				$.ajax({
					url : 'productInOut' ,
					data : {
						podtCode : insertCode ,
						manDate : insertDate ,
						podtInput : insertInput ,
						podtOutput : insertOutput ,
						podtEtc : insertEtc ,
						podtLot : insertLot
					} ,
					async : false ,
					success : function(datas) {
						
						ok = 2 ;						
						let podtCode = 'null' ;
						let manDatestart = '1910-12-25';
						let manDateend = '1910-12-25';
						
						$.ajax({
							url : 'productList' ,
							dataType : 'json' ,
							data : {
								podtCode : podtCode ,
								manDatestart : manDatestart ,
								manDateend : manDateend
							} ,
							async : false ,
							success : function(datas) {
								data = datas.productlist ;
								
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
			}
			if (ok == 2) {
				alert('저장완료되었습니다') ;
			}
		} 
		
	})
	
	var rowNo = new Array() ;
	
	grid.on('check' , (ev) => {
		rowNo[ev.rowKey] = grid.getValue([ev.rowKey],"qntInfono") ;
	})
	
	grid.on('uncheck' , (ev) => {
		delete rowNo[ev.rowKey] ;
	})
	
	$("#btnDelete").on("click" , function() {
		let ok = 1 ;
		for (let i = 0 ; i < rowNo.length ; i++) {
			if(rowNo[i] != null) {
				let qntInfono = rowNo[i] ;
				
				$.ajax({
					url : 'deleteInOut/' + qntInfono ,
					async : false ,
					success : function(datas) {
						ok = 2 ;
						
						let podtCode = 'null' ;
						let manDatestart = '1910-12-25';
						let manDateend = '1910-12-25';
						
						$.ajax({
							url : 'productList' ,
							dataType : 'json' ,
							data : {
								podtCode : podtCode ,
								manDatestart : manDatestart ,
								manDateend : manDateend
							} ,
							async : false ,
							success : function(datas) {
								data = datas.productlist ;
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
				delete rowNo[i] ;
			}
		}
		if (ok == 2) {
			alert('삭제완료되었습니다') ;
		}
	})
	
	let dialog2 = $("#qr").dialog({
		autoOpen : false ,
		modal : true ,
		width : 800 ,
		height : 500 ,
		buttons : {
			"QR코드" : function() {
				qr() ;
			} ,
			"닫기" : function() {
				dialog2.dialog("close") ;
			}
			
		}
	})
	
	const columns3 = [
		{
			header: '제품코드' ,
			name: 'podtCode' , 
			align: 'center'
		} ,
		{
			header: '제품명' ,
			name: 'podtName' ,
			align: 'center'
		} ,
		{
			header: '생산완료일' ,
			name: 'manDate2' ,
			align: 'center'
		} ,
		{
			header: '생산지시코드' ,
			name: 'comCode' ,
			align: 'center'
		} ,
		{
			header: '생산계획코드' ,
			name: 'manPlanNo' ,
			align: 'center'
		} ,
		{
			header: '주문코드' ,
			name: 'ordCode' ,
			align: 'center'
		} ,
	] ;
	
	let data3 ;
	
	const grid3 = new Grid({
		el : document.getElementById('qrTable') ,
		rowHeaders: [
			{ type : 'rowNum' }
		] ,
		height : 300 ,
		data : data3 ,
		columns : columns3
	})
	
	grid.on('click' , (ev) => {				
		if(ev.columnName != 'podtLot') {
			return ev.stop() ;
		}
		
		let columnname = grid.getValue([ev.rowKey],"podtLot") ;
		
		if (columnname != null) {
			
			let comCode = columnname.slice(0,10) ;
			
			$("#result").val(comCode) ;
      
			dialog2.dialog("open") ;
			
			$.ajax({
				url : 'selectQR/' + comCode ,
				dataType : 'json' ,
				async : false ,
				success : function(datas) {
					data3 = datas.qr ;
					grid3.resetData(data3) ;
					grid3.resetOriginData() ;
					grid3.refreshLayout() ;
				} , 
				error : function(reject) {
					console.log(reject) ;
				}
			})
		}
	})
	
	function qr() {
		let code = $("#result").val() ;
	
		// 집 192.168.0.8
		// 학원 192.168.0.60
		// 우리조서버 52.86.104.126:8080
		let url = "http://192.168.0.8/yedamfinal2/ProductTest2Page/" + code ;
		//let url = "http://192.168.0.8/yedam_final2/ProductTest2Page/" + code ;
		let option = "width = 355 , height = 355" ;
		window.open(url,"Lot조회",option) ;
	}
	
	$("#clearBtn").on("click" , function() {
		$("#txtPodtCode").val("") ;
		$("#manDatestart").val("") ;
		$("#manDateend").val("") ;
		grid.clear() ;
	})		
	//---------- ↑페이지 ----------
	//---------- ↓제품코드찾기 ----------
	let dialog = $("#findProduct").dialog({
		autoOpen : false ,
		modal : true ,
		width : 600 ,
		height : 400 ,
		buttons : {
			"닫기" : function() {
				dialog.dialog("close") ;
				grid2.clear() ;
				$("#podtName").val("") ;
			}
		}
	})
	
	$("#btnSearch").on("click" , function() {
		dialog.dialog("open") ;
		grid2.refreshLayout() ;
	})
	
	const columns2 = [
		{
			header: '제품코드' ,
			name: 'podtCode' , 
			align: 'center'
		} ,
		{
			header: '제품명' ,
			name: 'codeName' ,
			align: 'center'
		}
	] ;
	
	let data2 ;
	
	$("#btnPodtSearch").on("click" , function() {
		var podtName = $("#podtName").val() ;
		
		if (podtName == '') {
			alert('제품명을 입력하세요') ;
			return ;
		}
		
		$.ajax({
			url : 'findProduct/' + podtName ,
			dataType : 'json' ,
			async : false ,
			success : function(datas) {
				data2 = datas.findproduct ;
				grid2.resetData(data2) ;
				grid2.resetOriginData() ;
			} ,
			error : function(reject) {
				console.log(reject) ;
			}
		})
	})
	
	const grid2 = new Grid({
		el : document.getElementById('podtResult') ,
		rowHeaders: [
			{ type : 'rowNum' }
		] ,
		height : 300 ,
		data : data2 ,
		columns : columns2
	})
	
	grid2.on('click',(ev) => {
		let cusCode = data2[ev.rowKey].podtCode ;
		$("#txtPodtCode").val(cusCode) ;
		grid2.clear() ;
		dialog.dialog("close") ;
		$("#podtName").val("") ;
	})
	//---------- ↑제품코드찾기 ----------
</script>
</body>
</html>
