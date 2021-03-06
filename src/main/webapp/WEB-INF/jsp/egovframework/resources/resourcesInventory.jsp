<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>재고 조정 관리</title>
</head>
<body>
	<div style="width : 1500px ;">
		<span style="float: right;">
			<button type="button" id="helpBtn" style="border : none; background-color : #f2f7ff; color : #007b88; float : right ;">
				<i class="bi bi-question-circle"></i>
			</button>
		</span>
		<h4 style="margin-left: 10px">재고 조정 관리</h4>
	</div>
	<div id="top">
		<div>
			<span style="margin-top: 13px; float: left;"></span>
			<span style="float: right; margin-top: 4.5px;">
				<button id="btnAdd" class="btn">추가</button>	 &nbsp;&nbsp;
				<button id="btnDel" class="btn">삭제</button> &nbsp;&nbsp;
				<button id="btnSaveInventory" class="btn">저장</button> &nbsp;&nbsp;
			</span>
		</div>
	</div>
	
	<!-- 자재별 LOT 검색 모달 -->
	<div id="dialog-form-inventory" title="자재 LOT 검색"></div>
	
	<!-- 자재 검색 모달 -->
	<div id="dialog-form-rsc" title="자재 검색"></div>
	
	<!-- 그리드 설정 -->
	<div id="OverallSize" style="margin-left: 10px;"><br>
		<div id="grid" style="border-top: 3px solid #168; width: 1500px;"></div>
	</div>
	
	<!-- 도움말 모달입니다. -->
	<div id="helpModal" title="도움말">
		<hr>
		추가 : 조정할 재고를 선택 가능합니다<br><br>
		저장 : 입출고 구분, 자재 LOT, 입/출고 기입 후 저장이 가능합니다<br><br>
		실재고와 맞지 않는 부분은 조정해주는 페이지입니다.
		<br><br>
		<hr>
	</div>

<script type="text/javascript">

	//그리드 한글로 변환
	tui.Grid.setLanguage('ko');
	
	var code;
	var row;
	//-------- 도움말 모달 ----------
	var helpModal = $( "#helpModal" ).dialog({
	 autoOpen : false ,
	 modal : true ,
	 width:600, //너비
	 height:400, //높이
	 buttons: {
			"닫기" : function() {
				helpModal.dialog("close") ;
			}
		}
	});		
	
	//-------- 자재조회 모달 ----------
	var dialogRsc = $( "#dialog-form-rsc" ).dialog({
			autoOpen: false,
			modal: true,
			heigth : 500,
			width : 900,
			buttons: {
				"확인" : function (){
					for(i=0; i <gridRsc.getCheckedRows().length; i++ ){
						let a = gridRsc.getCheckedRows()[i]
						a.rowKey = i;
						grid.appendRow(a);
					}
					dialogRsc.dialog("close");
				},
				"닫기" : function() {
					dialogRsc.dialog("close");
				}
			},
		});
	
	//모달창(조회 클릭시 LOT별 입고)
	var dialoginventory = $( "#dialog-form-inventory" ).dialog({
			autoOpen: false,
			modal: true,
			heigth : 500,
			width : 900,
			buttons: {
				"닫기" : function() {
					dialoginventory.dialog("close") ;
				}
			},
		});
	
	
	//-------- 메인그리드 ----------
	var Grid = tui.Grid;
	Grid.applyTheme('default');
	
	var columns = [
					{
						header: '자재코드',
						name: 'rscCode'
					},
					{
						header: '자재명',
						name: 'rscName'
					},
					{
						header: '단위',
						name: 'rscUnit'
					},
					{
						header: '입출고 구분',
						name: 'storeFlag',
						editor: {
							type:'select',
							options: {
								listItems: [
											{ text: '정산입고', value: '정산입고' },
											{ text: '정산출고', value: '정산출고' },
									]
							}
						}
					},
					{
						header: '자재LOT',
						name: 'rscLot'
					},
					{
						header: '입고량',
						name: 'istCnt',
						editor: 'text',
						formatter(value) {
							if(value.value != null && value.value != '' ){
								return value.value.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
							}else{
								return value.value ;
							}
						}
					},
					{
						header: '출고량',
						name: 'ostCnt',
						editor: 'text',
						formatter(value) {
							if(value.value != null && value.value != '' ){
								return value.value.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
							}else{
								return value.value ;
							}
				        }
					},
					
				];
	
	//메인 그리드 api
	var dataSource = {
		  api: {
			  readData: { 
			    	url: 'resourcesInventory', 
			    	method: 'GET'
			    	},
		    	modifyData: { 
		    		url: 'resourcesStoreModify', 
		    		method: 'POST' 
		    		}
		  },
		  initialRequest : false,
		  contentType: 'application/json'
		};
	
	//메인 그리드 설정
	var grid = new Grid({
		  el: document.getElementById('grid'),
		  data: dataSource,
		  rowHeaders: ['checkbox'],
		  columns
		});
	
	//columnName = rscLot 그리드 클릭시 자재명에 있는 rscLot LOT 리스트 출력
	grid.on("click", function(ev){
		if(ev["columnName"]=="rscLot" && (grid.getValue(ev["rowKey"], 'rscCode')) != null){
			rscLotRowKey=ev["rowKey"];
				dialoginventory.dialog("open");
		
		$("#dialog-form-inventory").load("resourcesInventoryIn",
			function(){console.log("로드됨");
				code=grid.getValue(ev["rowKey"], 'rscCode');
				row=ev["rowKey"];
			})
		}
	});
	
	//columnName = rscCode 그리드 클릭시 자재리스트 출력
// 	grid.on("click", function(ev){
// 		if(ev["columnName"]=="rscCode"){
// 			rscRowKey=ev["rowKey"];
// 				dialogRsc.dialog("open");
	
// 		$("#dialog-form-rsc").load("recList",
// 			function(){
// 				console.log("자재조회 모달 로드됨")
// 			}
// 		)}
// 	});	
	
	
	
	//추가 버튼
	btnAdd.addEventListener("click", function(){
		dialogRsc.dialog("open");
		$("#dialog-form-rsc").load("recList",
				function(){
					console.log("자재 조회 모달 로드됨")
			})
		//grid.appendRow({});
	});
	
	//삭제 버튼
	btnDel.addEventListener("click", function(){
		grid.removeCheckedRows(true);
	});
	
	//저장 버튼
	btnSaveInventory.addEventListener("click", function(){
		grid.request('modifyData');
	});
	
	//저장시 데이터 다시 읽어서 수정한 품목(입고 완료한) 사라지게
	grid.on("response",function(){
		grid.clear();
	});
	
	//------------------ 도움말 버튼 이벤트 -----------------------
	helpBtn.addEventListener('mouseover' , () => {
		helpModal.dialog("open") ;
	});
	
</script>
</body>
</html>