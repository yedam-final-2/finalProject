<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자재 LOT재고 조정 조회</title>
<style type="text/css">
.in
	{
		color: #002bff;
		font-weight: bold;
}
.out
	{
		color: #f10000;
		font-weight: bold;
}
</style>
</head>
<body>
	<div style="width : 1500px ;">
		<span style="float: right;">
			<button type="button" id="helpBtn" style="border : none; background-color : #f2f7ff; color : #007b88; float : right ;">
				<i class="bi bi-question-circle"></i>
			</button>
		</span>
		<h4 style="margin-left: 10px">자재 LOT재고 조정 조회</h4>
	</div>
	<div id="top" style="height: 150px;">
		<div style="margin-top : 15px;  margin-left: 10px;">
			<span>
			조정일자  <input id="txtInven1" type="date" data-role="datebox" data-options='{"mode": "calbox"}'>
			  ~ 	<input id="txtInven2" type="date" data-role="datebox" data-options='{"mode": "calbox"}'><br>
			</span> 
			<div style="margin-top: 10px;">
				자재명	&nbsp;&nbsp;&nbsp;<input id="txtRsc2" class="inpBC" readonly style="border:0.5px solid gray;">&nbsp;&nbsp;&nbsp;&nbsp;
				자재코드	&nbsp;&nbsp;&nbsp;<input id="txtRsc1">
				<button id="btnFindRsc" style="border : none; background-color :#f8f8ff; color : #007b88;">
					<i class="bi bi-search"></i>
				</button>
			</div>
			<div id="dialog-form-rsc" title="자재 검색"></div>
			<div style="float:right;margin-bottom: 0px;margin-top: 15px;margin-right: 10px;">
				<button id="btnSelect" class="btn">조회</button>
				<button id="btn_reset" type="reset" class="btn">초기화</button>
			</div>
		</div>
	</div>
	
	<div id="OverallSize" style="margin-left: 10px;"><br>
		<div id="grid" style="border-top: 3px solid #168; height: 600px;"></div>
	</div>
	
	<!-- 도움말 모달입니다. -->
	<div id="helpModal" title="도움말">
		<hr>
		조회 : 재고조정한 자재 조회가 가능합니다<br><br>
		초기화 : 조정일자 ,자재명 초기화가 가능합니다<br><br>
		조정일자, 자재명일 입력하여 원하는 조건 검색하는 페이지입니다
		<br><br>
		<hr>
	</div>
	
<script type="text/javascript">

	//그리드 한글로 변환
	tui.Grid.setLanguage('ko');
	
	//옵션세팅
	themesOptions = { 
	            selection: {    background: '#007b88',     border: '#004082'  },//  <- 클릭한 셀 색상변경 border(테두리색) , background (백그라운드)
	            scrollbar: {    background: '#f5f5f5',  thumb: '#d9d9d9',  active: '#c1c1c1'    }, //<- 그리드 스크롤바 옵션
	            row: {    
	                hover: {    background: '#ccc'  }// <-마우스 올라갔을떄 한row 에 색상넣기
	            },
	            cell: {   // <- 셀클릭했을떄 조건들 주는것이다.
	                normal: {   background: '#fbfbfb',  border: '#e0e0e0',  showVerticalBorder: true    },// <- showVerticalBorder : 세로(아래,위) 테두리가 보이는지 여부
	                header: {   background: '#eee',     border: '#ccc',     showVerticalBorder: true    },// <- showVerticalBorder : 가로(양옆) 테두리가 보이는지 여부
	                rowHeader: {    border: '#eee',     showVerticalBorder: true    },// <- 행의헤더 색상영역
	                editable: { background: '#fbfbfb' },//  <-편집가능한 셀들의 색상을 주는영역
	                selectedHeader: { background: '#eee' },//  <- 선택한 셀의 백그라룬드	
	                disabled: { text: '#b0b0b0' }// <- 편집할수없는(비활성화된) 셀들에 대한 스타일 조절
	        }
	};

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

	//조정일자 초기값 
	var d = new Date();
	var nd = new Date(d.getFullYear(), d.getMonth(), d.getDate() - 7);
	document.getElementById('txtInven1').value = nd.toISOString().slice(0, 10);
	document.getElementById('txtInven2').value = d.toISOString().slice(0, 10);
	
	//초기화 버튼
	$("#btn_reset").on("click", function(){
		document.getElementById('txtInven1').value = nd.toISOString().slice(0, 10);
		document.getElementById('txtInven2').value = d.toISOString().slice(0, 10);
		$("#txtRsc1").val('');
		$("#txtRsc2").val('');
	})
	
	//-------- 자재조회 모달 ----------
	let dialogRsc = $( "#dialog-form-rsc" ).dialog({
			autoOpen: false,
			modal: true,
			width : 600 ,
			height : 600,
			buttons: {
				"닫기" : function() {
					dialogRsc.dialog("close") ;
				}
			},
		});
	
	//자재조회 모달창 오픈 
	$("#btnFindRsc").on("click", function(){
		dialogRsc.dialog("open");
		$("#dialog-form-rsc").load("recList2",
				function(){
					console.log("자재조회 모달창 로드됨")
				})
		});
	
	//모달창(자재조회)에서 클릭한 값 가지고 와서 input 태그에 넣고 모달 닫기
	function clickRsc(rscCode, rscName){
		$("#txtRsc1").val(rscCode);
		$("#txtRsc2").val(rscName);
		dialogRsc.dialog("close");
	};
	
	//-------- 메인그리드 ----------
	var Grid = tui.Grid;
	
	var columns = [
					{
						header: '구분',
						name: 'storeFlag',
						sortable: true,
						sortingType: 'desc'
					},
					{
						header: '조정일자',
						name: 'storeDate',
						sortable: true,
						sortingType: 'desc'
					},
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
						header: '자재LOT',
						name: 'rscLot',
						sortable: true,
						sortingType: 'desc'
					},
				    {
						header: '입고량',
						name: 'istCnt',
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
		    	url: 'resourcesInven', 
		    	method: 'GET'
		    	}
		  },
		  contentType: 'application/json'
		};
	
	var grid = new Grid({
		  el: document.getElementById('grid'),
		  data: null,
		  columns: columns,
		  pageOptions: {
			    useClient: true,
			    perPage: 15
			},
			summary: {
			    position: 'bottom',
			    height: 40, 
			    columnContent: {
			    	istCnt: {
			        template(summary) {
			        	return '입고량: ' + (summary.sum*1).toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
			        }
			      },
			      ostCnt: {
				        template(summary) {
				        	return '출고량: ' + (summary.sum*1).toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
				        }
				      },
			    	}
			  },
			  bodyHeight: 450
		});
	
	grid.on('click' , (ev) => {
		//selection 옵션을 주고 얘들을 세팅해야 클릭했을떄 색상이 바뀌고 색상이 사라지고 한다.
		grid.setSelectionRange({
	    	start: [ev.rowKey, 0],
	    	end: [ev.rowKey, grid.getColumns().length-1]
	    })
	});

	//조회버튼 클릭시 input 태그의 값을 넘겨서 원하는 데이터를 가지고 온다
	$("#btnSelect").on("click", function(){
			var rscCode = $("#txtRsc1").val();
			var storeDate = $("#txtInven1").val();
			var storeDate2 = $("#txtInven2").val();
			$.ajax({
				url :'resourcesInven',
				data: {'rscCode' : rscCode, 'storeDate':storeDate, 'storeDate2' : storeDate2 },
				contentType: 'application/json; charset=UTF-8'
			}).done(function(da){
				var datalist = JSON.parse(da);
				grid.resetData(datalist["data"]["contents"]);

			})
		});
	
	//자재구분이 정산입고
	grid.on("onGridUpdated", function(ev){
		for(i=0; i<grid.getRowCount(); i++){
			if(grid.getValue(i, "storeFlag") == '정산입고'){
				grid.addCellClassName(i, 'storeFlag', 'in')
			}else if(grid.getValue(i, "storeFlag") == '정산출고'){
				grid.addCellClassName(i, 'storeFlag', 'out')
			}
		}

	})
	
	//if  storeFlag == '정산입고' - 빨강 //  storeFlag == '정산출고' - 파랑
	//addRowClassName(rowKey, className) 
	
//------------------ 도움말 버튼 이벤트 -----------------------
helpBtn.addEventListener('mouseover' , () => {
	helpModal.dialog("open") ;
})		
	
tui.Grid.applyTheme('default', themesOptions);	
	
	
</script>
</body>
</html>