<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko" dir="ltr">
<head>
<meta charset="utf-8">
<title>제품BOM</title>

<style>
div.left {
   margin-left: 6px;
   float: left;
   box-sizing: border-box;
   padding: 5px;
}

div.right {
   float: right;
   width: 35%;
   padding: 5px;
   box-sizing: border-box;
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
		<h4 style="margin-left: 10px">제품BOM 관리</h4>
	</div>

   <div id="top" style="height: 103px;">
      <div style="height: 40px; margin-top: 12px;">
		 <span style="float: right; ">
            <button id="resetBtn" type="button" class="btn"
               style="padding: 5px 30px;">리셋</button> &nbsp;&nbsp;
            <button id="BomSave" type="button" class="btn"
               style="padding: 5px 30px;">저장</button> &nbsp;&nbsp;
            <button id="BomDataAllDelete" type="button" class="btn"
               style="padding: 5px 30px;">BOM 삭제</button> &nbsp;&nbsp;
         </span>

     
	      <div style="margin-left: 10px;">
	         <span>제품코드 <input id="proIdInp" type="text" class="inpBC" readonly>
		         <button type="button" id="proId" style="border : none; background-color :#f8f8ff; color : #007b88;">
				 	<i class="bi bi-search"></i>
				 </button>
	         </span> &nbsp;&nbsp; <span> 제품명 <input id="proName" type="text" class="inpBC" readonly>
	         </span>
	   	  </div>
	      
	      <div style="height: 40px; margin-top: 15px; margin-bottom: 5px; margin-left: 10px;">
	         <span>제품분류 <input id="proFlag" type="text" class="inpBC" readonly></span>
	          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	          <span>생산구분 <input id="manFlag" type="text" class="inpBC" readonly></span> &nbsp;
	         <span>관리단위 <input id="proUnit" type="text" class="inpBC" readonly></span>
	      </div>
	
	   </div>
   </div>
	<br>
   
   <div id="OverallSize" style="width: 1515px;">
      <div class="left">
         <span style="font-size: 1.5em; color: #25396f"> 제품별 소모자재 관리 </span>
          <span style="float: right;  color: rgb(158, 158, 158);">
            <button id="btnLeftAdd" type="button" class="btn">자재추가</button> &nbsp;
            <button id="btnLeftDel" type="button" class="btn">선택삭제</button>
         </span> <br>

         <div id="MatGrid"
            style="border-top: 3px solid #168; width: 835px; margin-top: 10px;"></div>
      </div>

      <div class="right">
         <span style="font-size: 1.5em; color: #25396f"> 공정흐름 관리 </span>
         <span style="float: right;  color: rgb(158, 158, 158);">
            <button id="btnRightAdd" type="button" class="btn">공정추가</button> &nbsp;
            <button id="btnRightDel" type="button" class="btn">전체삭제</button>
         </span>
         <br>

         <div id="ProcGrid" style="border-top: 3px solid #168; margin-top: 10px;"></div>

      </div>
		
      <div id="dialog-form" title="모달">
         <div id="ProGrid" ></div>
      </div>
   </div>
   
   <div id="helpModal" title="도움말">
		<hr>
		돋보기 버튼을 눌러서 제품코드를 조회 후 클릭하면 선택이 됩니다.<br><br>
		관리단위 : 제품이 공정전체를 돌아서 한번 나오는양 <br><br>
		공정흐름관리 : 왼쪽끝 점들을 클릭드로우 하여 위치를이동할수있고<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		위치가 이동되면 공정들의 순서를 변경할수 있습니다.<br><br>
		BOM삭제 : 선택된 제품코드 를 기준으로 등록된 "사용자재" , "공정흐름"<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		들의 데이터들을 초기화 할수있습니다.<br><br>
		<!-- 추가 : 
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;업체코드 : 구매고객/판매고객을 선택하면 저장시 자동으로 입력됩니다.<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고객구분 : 업체코드를 선택 시 자동으로 입력됩니다.<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;모든 값을 다 입력해야 저장이 가능합니다.<hr>
		초기화 : 입력한 조회 조건을 초기화합니다. -->
	</div>
</body>

<script>
//-------- toastr 옵션설정 ----------
toastr.options = {
        "closeButton": true,  //닫기버튼(X 표시)
        "debug": false,       //디버그
        "newestOnTop": false,
        "progressBar": true,  //진행률 표시
        "positionClass": "toast-top-center",
        "preventDuplicates": false,    //중복 방지(같은거 여러개 안뜸)
        "onclick": null,             //알림창 클릭시 alert 창 활성화 (다른것도 되는지는 연구해봐야함)
        "showDuration": "3",
        "hideDuration": "100",
        "timeOut": "2000",   //사라지는데 걸리는 시간
        "extendedTimeOut": "1000",  //마우스 올리고 연장된 시간
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "fadeIn",
        "hideMethod": "fadeOut",
        "tapToDismiss": false
      }
      
	  tui.Grid.setLanguage('ko');
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

      //-------- 모달 설정 ----------
      var dialog = $( "#dialog-form" ).dialog({
         autoOpen : false ,
         modal : true ,
         width:600, //너비
         height:500 //높이
      });
      
      //------제품선택 모달 --------
         $("#proId").on('click' , () => {
            dialog.dialog( "open" ) ;
            ProGrid.refreshLayout() ; //그리드는 새로고침해서 빠르게 다시 가져오는 함수
      });
      
      var Grid = tui.Grid;
      
      var ProDatas;
      
      //------제품조회 ajax --------
      $.ajax({
         url : './ProFind',
         dataType : 'json',
         async : false,
      }).done( (rsts) => {
         ProDatas = rsts.data
      })
      
      //------제품 모달 그리드 헤드 --------
      const ProGrid = new Grid({
         el : document.getElementById('ProGrid'),
         data : ProDatas ,
         columns : [
            { header : '제품코드'   , name : 'podtCode'   , align : 'center' },
            { header : '제품명'   , name : 'codeName'   , align : 'center' },
            { header : '제품분류'   , name : 'podtFlag'   , align : 'center' }
         ],
         bodyHeight: 350
      });
      
      //------클릭한 제품 코드 선택 --------
      ProGrid.on('click' , (ev) =>{
         var proCode = ProDatas[ev.rowKey].podtCode;
         BomFindAll(proCode);
      })
      
      
      var proData ;
      var rscData ;
      var pData ;
      var ProcData ;
      var MatDatas ; 
      
      //------BOM 전체 조회 --------
      function BomFindAll(proCode) {
         
         //------제품코드를 기준으로 제품상세 , BOM자재 , 공정흐흐름 들의정보불러오기 --------
         $.ajax({
            url : './DetailAll/'+proCode,
            dataType : 'json',
            async : false
         }).done( (rsts) =>{
        	 console.log(rsts)
            proData = rsts.ProDetail;
            document.getElementById("proIdInp").setAttribute("value",proCode);         //제품코드
            document.getElementById("proName").setAttribute("value",proData[0].codeName);   //제품명
            document.getElementById("proFlag").setAttribute("value",proData[0].podtFlag);   //제품구분
            document.getElementById("manFlag").setAttribute("value",proData[0].manFlag);   //제품구분
            document.getElementById("proUnit").setAttribute("value",proData[0].podtUnit);   //제품 관리단위
            rscData = rsts.rscDetail;   //BOM 자재
     		console.log(rscData);
            pData = rsts.ProcDetail;   //공정흐름
         })      
         
         MatDatas = rscData;          //제품코드 기준 등록된 자재소모량 정보 조회
         MatGrid.resetData(MatDatas); //모달에서 새로 데이터를 입력할것이기 때문에 리셋하고 MatDatas 데이터로 변경하고
         MatGrid.resetOriginData();   //모달을 새로고침 해서 띄운다. / 이미있던 그리드에 값을 뒤늦게 입력해줄려면 이 두줄이 필수
         
         ProcData = pData ;           //제품코드 기준 등록된 공정흐름 정보 조회
         ProcGrid.resetData(ProcData);
         ProcGrid.resetOriginData();
         
 //        MatGrid.appendRow({})  
         dialog.dialog( "close" ) ;
         
      }
      
      var aaa ;
      var dataA ;
      var dataArray = new Array();
      
      //------자재코드 조회--------
      $.ajax({
         url : './rscFind',
         dataType : 'json',
         async : false,
      }).done( (rsts) => {
         //grud 에 있는 listItems 형식대로 배열을 만들어서 헤드에 넣어줘야 한다.
         aaa = rsts.data
         aaa.forEach( (rsts) => {
            //그리드 형식에 맞춰서 Array 타입 에 데이트 추가
             dataA = { text : rsts.rscCode, value : rsts.rscCode }
             dataArray.push(dataA);
            
         })
      })
      
       var bbb ;
      var dataB ;
      var ProcDataArray = new Array();
       //------공정코드 조회--------
      $.ajax({
         url : './ProcFind',
         dataType : 'json',
         async : false,
      }).done( (rsts) => {
         //grud 에 있는 listItems 형식대로 배열을 만들어서 헤드에 넣어줘야 한다.
         bbb = rsts.data
         bbb.forEach( (rsts) => {
            //그리드 형식에 맞춰서 Array 타입 에 데이트 추가
             dataB = {
                     text : rsts.code , value : rsts.code
                  }
             ProcDataArray.push(dataB);
            
         })
      })
      
                 
      //------자재 그리드 헤드 --------
      const MatGrid = new Grid({
         el : document.getElementById('MatGrid'),
         data : MatDatas ,
         columns : [ 
            { 
               header : '자재코드'   , name : 'resCode'   , align : 'center' , validation : { required : true } , 
                   formatter: 'listItemText',
                   editor: {
                        type: 'select',
                        options: {
                           //dataArray -> ajax 에서 값을받아서 Array 타입 과 그리드 형식을 갖춰서 만든 변수이다
                          listItems: dataArray
                        }
                      }
           	 },
            { header : '자재명'   	, name : 'codeName'   	, align : 'center'},
            { header : '단위'   		, name : 'rscUnit'   	, align : 'center'},
            { header : '자재소모량'   	, name : 'resUsage'   	, align : 'center' , editor : 'text' 	, validation : { required : true }  },
            { header : '공정코드'     	, name : 'procCode'   	, align : 'center' , editor : 'text'	, validation : { required : true }, 
                formatter: 'listItemText',
                editor: {
                     type: 'select',
                     options: {
                        //dataArray -> ajax 에서 값을받아서 Array 타입 과 그리드 형식을 갖춰서 만든 변수이다
                       listItems: ProcDataArray
                     }
                   }
            },
            { header : '비고'      	, name : 'resEtc'   	, align : 'center' , editor : 'text'	},
            { header : 'DB'			, name: 'crud'		  	, hidden : true }
         ],
         rowHeaders: ['checkbox'],
         bodyHeight: 257
      });
      
      
      //제품코드로 조회해서 가져온 코드는 변경 안되도록 해주기
      MatGrid.on('editingStart' , (ev) => {
      	try{
      		if (ev.columnName == "resCode"){
      			var CRUD = MatGrid.getValue(ev.rowKey ,'crud'); 
      			if ( CRUD != null && CRUD != ''){ 
      				//success: 성공(초록) , info:정보(하늘색) , warning:경고(주황) , error:에러(빨강)
      				alert("저장된 자재코드는 수정이 불가능합니다 ")
      				ev.stop();
      			}
      		}
      	}catch (err)
          {
              alert('코드수정 방지 에러 ' + err);
          }
      });
      
    	
       //----------자재코드로 자재명 출력 부분 -------------
       MatGrid.on('editingFinish' , (ev) => {
          var resCode  ;
          var jsonData ;
          if(ev.columnName == "resCode"){
          resCode = ev.value ;
          jsonData = { resCode : resCode } //앞에가 키값 , 뒤에서 벨류값으로 보여진다.
          var Metadata = getCodeNm(jsonData)  //ajax 호출해서 리턴값을 돌려받는다.
            if ( Metadata != '' || Metadata != null || Metadata != undefined ) {
               MatGrid.setValue(ev.rowKey , 'codeName' , Metadata);
            }
          

          var MaterialUnit = getUnitFn(jsonData) //자재단위 호출
          if ( MaterialUnit != '' || MaterialUnit != null || MaterialUnit != undefined ) {
              MatGrid.setValue(ev.rowKey , 'rscUnit' , MaterialUnit);
           }
          }
          
          
          //----------자재코드 중복체크 -------------
          var i = 0 ;
          var Datas ;
             if(ev.columnName === 'resCode' )
                {
                 Datas = MatGrid.getData();
                var chkCodeId = true;
                Datas.forEach( (rst) => {
                   if (chkCodeId == true )
                      {
                      if(i !=ev.rowKey)
                         {
                         if(MatGrid.getValue(ev.rowKey , 'resCode') == rst.resCode)
                            {
                        	   alert("이미 입력한 코드입니다." + rst.code);
                               chkCodeId = false;
                               MatGrid.setValue(ev.rowKey , 'resCode'  , '');
                                MatGrid.setValue(ev.rowKey , 'codeName' , '');
                                return false;
                            }
                         }
                      }
                      i++;
                   });
                }     
       });
       
          

          //----------자재코드로 자재명 처리 -------------
          function getCodeNm(jsonData) {
            
          var Metadata ; 
          var CodeName ;
          $.ajax({
             url: './proNameFind' ,
             type: "post",
             dataType: 'json',
             data: JSON.stringify(jsonData),
             contentType: "application/json",
             async : false, //  동기식으로 처리하여 결과를 되돌린다.
             success: function(datas) {
                CodeName = datas.data
                if(CodeName != null ){
                   Metadata = CodeName.codeName;
                }else{
                	alert("자재명이 없는 코드입니다.")
                }
             },
             error: function(err) {
                alert("코드명호출 에러 " + err);
             }
          });
          
          return Metadata;
          
          
       };
       
     //----------자재코드로 자재단위 호출 -------------
       function getUnitFn(jsonData) {
         
       var Unitdata ; 
       var MatUnit ;
       $.ajax({
          url: './proNameFind' ,
          type: "post",
          dataType: 'json',
          data: JSON.stringify(jsonData),
          contentType: "application/json",
          async : false, //  동기식으로 처리하여 결과를 되돌린다.
          success: function(datas) {
        	  MatUnit = datas.rscUnit
              if(MatUnit != null ){
            	  Unitdata = MatUnit.rscUnit;
              }else{
            	  alert("자재단위가 없는 코드입니다.")
              }
           },
          error: function(err) {
             alert("코드단위 호출 에러 " + err);
          }
       });
       
       return Unitdata;
       
       
    };
       
 ///////// ↑↑↑ 자재코드 //////////////// ↓↓↓ 공정 관련코드 //////////////////      
       
       
     
       
       //------공정흐름 그리드 헤드 --------
      const ProcGrid = new Grid({
         el : document.getElementById('ProcGrid'),
         data : ProcData ,
         columns : [
            { header : '공정코드'   , name : 'procCode'   , align : 'center' , validation : { required : true } ,
               	   formatter: 'listItemText',
                editor: {
                     type: 'select',
                     options: {
                       listItems: ProcDataArray
                     }
                   } 
            
            },
            { header : '공정명'   , name : 'codeName'   , align : 'center' },
            { header: 'DB'		, name: 'crud'		  , hidden : true }
         ],
         rowHeaders: ['rowNum'],
         draggable: true,
         bodyHeight: 417
      });
       
       
      //제품코드로 조회해서 가져온 코드는 변경 안되도록 해주기
      ProcGrid.on('editingStart' , (ev) => {
      	try{
      		if (ev.columnName == "procCode"){
      			var CRUD = ProcGrid.getValue(ev.rowKey ,'crud'); 
      			if ( CRUD != null && CRUD != ''){ 
      				//success: 성공(초록) , info:정보(하늘색) , warning:경고(주황) , error:에러(빨강)
      				alert("등록된 공정코드는 수정이 불가능합니다.")
      				ev.stop();
      			}
      		}
      	}catch (err)
          {
              alert('코드수정 방지 에러 ' + err);
          }
      });
      
      
      /*----------@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      			  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ------------- */
      ProcGrid.on('drop' , (ev) => { //그리드 데이터 드로우 끝난 이후 이벤트 시작
      	console.log(ProcGrid.getData());
      	console.log(ProcGrid.getModifiedRows());
      });
       
       
       
   	   //----------공정코드로 공정명 불러오는기능 -------------
       ProcGrid.on('editingFinish' , (ev) => {
    	   
    	   var procCode  ;
           var JsonData ;
           if(ev.columnName == "procCode"){
        	   procCode = ev.value ;
        	   JsonData = { procCode : procCode } //앞에가 키값 , 뒤에서 벨류값으로 보여진다.
            var PrNmData = getCoNm(JsonData)  //ajax 호출해서 리턴값을 돌려받는다.
             if ( PrNmData != '' || PrNmData != null || PrNmData != undefined ) {
            	 ProcGrid.setValue(ev.rowKey , 'codeName' , PrNmData);
             } 
           }
        
           
           
           
           
         //----------공정코드 중복체크 -------------
           var i = 0 ;
           var Datas ;
              if(ev.columnName === 'procCode' )
                 {
                  Datas = ProcGrid.getData();
                 var chkCodeId = true;
                 Datas.forEach( (rst) => {
                    if (chkCodeId == true )
                       {
                       if(i !=ev.rowKey)
                          {
                          if(ProcGrid.getValue(ev.rowKey , 'procCode') == rst.procCode)
                             {
                        	  	alert("이미 등록된 공정입니다");
                                chkCodeId = false;
                                ProcGrid.setValue(ev.rowKey , 'procCode'  , '');
                                ProcGrid.setValue(ev.rowKey , 'codeName' , '');
                                 return false;
                             }
                          }
                       }
                       i++;
                    });
                 }
       });
       
       
       //----------공정코드로 공정명 호출 함수 -------------
       function getCoNm(JsonData) {
         
       var PrNmData ; 
       var CoNm ;
       $.ajax({
          url: './ProcNmFind' ,
          type: "post",
          dataType: 'json',
          data: JSON.stringify(JsonData),
          contentType: "application/json",
          async : false, //  동기식으로 처리하여 결과를 되돌린다.
          success: function(datas) {
        	  CoNm = datas.data
             if(CoNm != null ){
            	 PrNmData = CoNm.codeName;
             }else{
            	 alert("공정명이 없는 코드입니다")
             }
          },
          error: function(err) {
             alert("공정명 호출 에러 " + err);
          }
       });
       
       return PrNmData;
       
       
    };
    
     //----------BOM 저장버튼 ---------------
     BomSave.addEventListener("click" , () => {
    	var Check = 0 ;
    	var Pdata = ProcGrid.getData();
    	//공정흐름 영역
    	var ProcModiRow = ProcGrid.getModifiedRows();
    	
    	var ProcInput = ProcModiRow.createdRows ;
	    	if(ProcInput.length > 0) {
	    		 var proIdValue = document.getElementById("proIdInp").value ;
	        	 var num = 0 ;	
	        	 var PI ;
	        	 var ProcInpData = new Array();
	        	 //그리드 rowNum 값 찾아서 그걸 index 값에 넣어주는 for영역
	    		 for(let a = 0 ; a<ProcInput.length ; a++){
	    			let ProcRowNum = ProcInput[a]._attributes;
	    	     	 try{
	    	    		 if(ProcInput[a].procCode == null || ProcInput[a].procCode == '' || ProcInput[a].procCode == undefined)
	    	    			{
	    	    				toastr["error"]("필수코드 미입력");  
	    						return false; 
	    	    			}
	    	    			 else
	    	    				 {
	    	    				 PI = {
	    		    					procCode  : ProcInput[a].procCode,
	    		    					podtCode  : proIdValue,
	    		    					procIndex : ProcRowNum.rowNum
	    		    				 }
	    		    			   ProcInpData.push(PI);
	    		    			   num++ ;
	    	    				 }
	    	    		 
	    	    	 }catch (err) {
	    	 			alert('공정추가 오류 '+ err);
	    	 		}
	    	    	
	    		 }   		 
	    	      	if(num>0){ 
	    	    	   $.ajax({
	    	    		 url : './ProcInsert',
	    	    		 type : 'post',
	    	    		 data : JSON.stringify(ProcInpData),
	    	    		 contentType : 'application/json;',
	    	             async : false, 
	    	             success: (datas) => {
	    	            	 Check++ ;

	    	             },
	    	             error: (err) => {
	    	                alert("공정데이터 추가 ajax 오류 " + err);
	    	             }
	    	          });  
	    	    	} 
	    	}
	    	
		   
		//------------- 공정흐름 업데이트 ---------------------
	    var ProcUpdt = ProcModiRow.updatedRows;
		if(ProcUpdt.length > 0){
			var proIdValue = document.getElementById("proIdInp").value ;
       	 	var num = 0 ;	
       	 	var PU ;
       		var ProcUpData = new Array();
			var ProcUpdtData = ProcGrid.getData();
     		for(let u = 0 ; u < ProcUpdtData.length ; u++){
     			let ProcRowNum = ProcUpdtData[u]._attributes ;
	     			try{
	   	    		 	
	     				PU = {
	   		    				procCode  : ProcUpdtData[u].procCode,
	   		    				podtCode  : proIdValue,
	   		    				procIndex : ProcRowNum.rowNum
	   		    			 }
	   	    			ProcUpData.push(PU);
	   		    			 num++ ;
	   	    	 }catch (err) {
	   	 			alert('공정흐름 업데이트 오류 '+ err);
	   	 		}
     		}
     		 if(num>0){ 
 	    	   $.ajax({
 	    		 url : './ProcUpdate',
 	    		 type : 'post',
 	    		 data : JSON.stringify(ProcUpData),
 	    		 contentType : 'application/json;',
 	             async : false, 
 	             success: (datas) => {
 	            	Check++ ;
 	             },
 	             error: (err) => {
 	                alert("공정데이터 추가 ajax 오류 " + err);
 	             }
 	          });  
 	    	} 
     		
     		
		}
    	
		
    	//------------------ 자재 영역 ----------------------
     	var MatModiRow = MatGrid.getModifiedRows();
    	
    	var MatInput = MatModiRow.createdRows ;
	    	if(MatInput.length > 0) {
	    		let attr = Minpt(MatInput);
	    		if(attr){
	    			Check++;
	    			console.log("자재 데이터 추가완료")
	    		}
	    	}
	 
	    var MatUpdate = MatModiRow.updatedRows;
	    	if(MatUpdate.length>0){
	    		let attr = MUpdate(MatUpdate);
	    		if(attr){
	    			Check++;
	    			console.log("자재 업데이트")
	    		}
	    	}
	    	
	    	
    	var MatDelete = MatModiRow.deletedRows ;
	    	if(MatDelete.length > 0) {
	    		MDelt(MatDelete);
	    	}
	    	
	    	
	    	
	    if(Check > 0){
      		toastr["success"]("데이터 저장완료"); 
	    }
    	
     })
     
     //---------- BOM 삭제버튼 이벤트 ---------------
     BomDataAllDelete.addEventListener("click" , () => {
    	var proIdValue = document.getElementById("proIdInp").value;
  	   
 	  	if(proIdValue == '' || proIdValue == null)
 	   		{
 	  			alert("조회된 BOM정보가 없습니다")
 	   		}
 	   		else
 	   		{
 		 		if(confirm(proIdValue + '의 BOM을 삭제 하시겠습니까?'))
 		 		{
	    		  		Pdelete(proIdValue);
	    		  		Mdelete(proIdValue);
	    		  		ProcGrid.clear();
	    		  		MatGrid.clear();
	    	   		}
 	   		}	    
    	 
     })
    	
      
             
      //----------자재 그리드 행추가 ---------------
       btnLeftAdd.addEventListener("click", () => {
          MatGrid.appendRow({})      
          
          
       })
       //----------체크된 그리드행삭제 ---------------
       btnLeftDel.addEventListener("click", () => {
          MatGrid.removeCheckedRows(true);
          
       })
       
       //----------공정흐름 그리드 행추가 ---------------
       btnRightAdd.addEventListener("click", () => {
           
           //index 숫자 증가 부분
           var indexData ;
           var ProcGridData = ProcGrid.getData();
           ProcGridData.forEach( (datas) => {
              indexData = datas.procIndex ; 
              RowKey = datas.rowKey;
           })
           if(indexData == undefined || indexData == null){
              indexData = 1; //첫번째 행에선 undefined 이 뜨기떄문에 +1
           }else{

              indexData++; //2번째 행부턴 이미 있는값에 +1씩
           }
           
           ProcGrid.appendRow({}) //여기서 미리 행을 추가해줘야 rowKey 가 밑에서 잡힌다
           
           //rowKey 찾는 영역(위에선 못찾음)
           var Pdata = ProcGrid.getData();
           var RowKey ;
           Pdata.forEach( (datas) => {
              RowKey = datas.rowKey
           })
		   
           ProcGrid.setValue(RowKey , 'procIndex' , indexData);
          
           
       })
       
       btnRightDel.addEventListener('click' , (ev) => {
    	   var proIdValue = document.getElementById("proIdInp").value;
    	   
    	  	if(proIdValue == '' || proIdValue == null)
    	   		{
    		   		toastr["info"]("조회된 BOM정보가 없습니다")
    	   		}
    	   		else
    	   		{
    		 		if(confirm('공정흐름을 초기화 하시겠습니까?'))
    		 		{
	    		  		Pdelete(proIdValue); 	//DB랑 먼저 연결해서 삭제를 해줘야 알림창이 정상적으로 뜬다
	    		  		ProcGrid.clear();		//View 에서 삭제를 해줘야한다.
	    	   		}
    	   		}	    
       })
       	
       
       
    	
    
	  //공정흐름 삭제 이벤트처리
   	  function Pdelete(proIdValue) {
			var param = {podtCode : proIdValue}
			var PgridDt = ProcGrid.getData() ;
			
			if(PgridDt.length > 0) {
				
			
				$.ajax({
	 	    		 url : './ProcDelete',
	 	    		 type : 'post',
	 	    		 data : JSON.stringify(param),
	 	    		 contentType : 'application/json;',
	 	             async : false, 
	 	             success: (datas) => {
	 	            	 console.log(datas);
	 	            	 toastr["success"]("공정흐름 데이터 삭제완료"); 
	 	             },
	 	             error: (err) => {
	 	                alert("공정흐름 삭제 오류 " + err);
	 	             }
	 	          });  
			}else{
				toastr["info"]("삭제할 데이터가 없습니다"); 
			}
	    	
		}
	  
	  
   	//자재 데이터 추가(인설트)
    function Minpt(MatInput) {
   	 var proIdValue = document.getElementById("proIdInp").value ;
   	 var num = 0 ;	
   	 var MI ;
   	 var Check = false ;
   	 var MatInpData = new Array();
	     	 try{
	     		MatInput.forEach( (rst) => {
	    			 if(rst.resCode == null || rst.resCode == '' || rst.resCode == undefined || rst.procCode == null || rst.procCode == '')
	    			 {
	    				alert("필수입력코드 미입력");  
						return false; 
	    			 }
	    			 else
	    				 {
	    				 MI = {
	    						 podtCode 	: proIdValue,
	    						 resCode  	: rst.resCode,
	    						 resUsage 	: rst.resUsage,
	    						 procCode	: rst.procCode,
	    						 resEtc 	: rst.resEtc
		    				 }
	    				 MatInpData.push(MI);
		    			   num++ ;
	    				 }
	    		 });
	    		 
	    	 }catch (err) {
	 			alert('자재 데이터 오류 '+ err);
	 		} 
	    	 
	    	 if(num > 0){ 
		    	 $.ajax({
		    		 url : './ResInsert',
		    		 type : 'post',
		    		 data : JSON.stringify(MatInpData),
		    		 contentType : 'application/json;',
		             async : false, 
		             success: (datas) => {
		            	 Check = true ;
		             },
		             error: (err) => {
		                alert("자재데이터 추가 ajax 오류 " + err);
		             }
		          });
	    	 }
	    	 return Check ;
		}
   	
   	
    //---------- 자재 업데이트 ---------------
   	function MUpdate(MatUpdate) {
   		var proIdValue = document.getElementById("proIdInp").value ;
      	 var num = 0 ;	
      	 var MU ;
      	 var Check = false ;
      	 var MatUpdtData = new Array();
   	     	 try{
   	     		MatUpdate.forEach( (rst) => {
	   	     		 if(rst.resCode == null || rst.resCode == '' || rst.resCode == undefined || rst.procCode == null || rst.procCode == '')
	    			 {
	   	     			alert("필수입력코드 미입력");  
						return false; 
	    			 }
	    			 else
	    				 {
	    				 MU = {
	    						 podtCode 	: proIdValue,
	    						 resCode  	: rst.resCode,
	    						 resUsage 	: rst.resUsage,
	    						 procCode	: rst.procCode,
	    						 resEtc 	: rst.resEtc
		    				 }
   	    				MatUpdtData.push(MU);
   		    			   num++ ;
   	    				 }
   	    		 });
   	    		 
   	    	 }catch (err) {
   	 			alert('자재 데이터 오류 '+ err);
   	 		} 
   	    	 
   	    	 if(num > 0){ 
   		    	 $.ajax({
   		    		 url : './ResUpdate',
   		    		 type : 'post',
   		    		 data : JSON.stringify(MatUpdtData),
   		    		 contentType : 'application/json;',
   		             async : false, 
   		             success: (datas) => {
   		            	 Check = true ;
   		             },
   		             error: (err) => {
   		                alert("자재 업데이트 ajax 오류 " + err);
   		             }
   		          });
   	    	 }
   	    	 return Check ;
		
	}
   	
   	
    //---------- 자재 체크된 데이터 삭제 ---------------
   	function MDelt(MatDelete) {
      	 var num = 0 ;	
      	 var MU ;
      	 var MatDeltData = new Array();
      	 var podtCode = document.getElementById('proIdInp')
   	     	 try{
   	     		MatDelete.forEach( (rst) => {
   	    			 if(rst.resCode == null || rst.resCode == '' || rst.resCode == undefined)
   	    			 {
   	    				toastr["error"]("삭제할 코드가 없습니다");  
   						return false; 
   	    			 }
   	    			 else
   	    				 {
   	    				console.log(rst)
   	    				MU = { resCode : rst.resCode ,
   	    					   podtCode : podtCode.value }
	   	    				 
	   	    				MatDeltData.push(MU);
	   		    			   num++ ;
   	    				 }
   	    			console.log(MatDeltData)
   	    		 });
   	    		 
   	    	 }catch (err) {
   	 			alert('자재 삭제 오류 '+ err);
   	 		} 
   	    	 
   	    	if(num > 0){ 
   	    	 $.ajax({
   	    		 url : './ResDelete',
   	    		 type : 'post',
   	    		 data : JSON.stringify(MatDeltData),
   	    		 contentType : 'application/json;',
   	             async : false, 
   	             success: (datas) => {
   	            	 toastr["success"]("자재 삭제 완료"); 
   	             },
   	             error: (err) => {
   	                alert("자재 삭제 ajax 오류 " + err);
   	             }
   	          });
   	    	}
      	 	
	}
    
    
  	  //자재 BOM 전체 삭제
 	  function Mdelete(proIdValue) {
			var param = {podtCode : proIdValue}
			var MgridDt = MatGrid.getData() ;
			
			if(MgridDt.length > 0) {
				
			
				$.ajax({
	 	    		 url : './ResAllDelete',
	 	    		 type : 'post',
	 	    		 data : JSON.stringify(param),
	 	    		 contentType : 'application/json;',
	 	             async : false, 
	 	             success: (datas) => {
	 	            	 console.log(datas);
	 	            	 toastr["success"]("자재 데이터 삭제 완료"); 
	 	             },
	 	             error: (err) => {
	 	                alert("자재BOM 삭제 오류 " + err);
	 	             }
	 	          });  
			}else{
				toastr["info"]("삭제할 데이터가 없습니다"); 
			}
	    	
		}
  	  
 	 //------------ 도움말 버튼 이벤트 ---------------
 	 helpBtn.addEventListener('mouseover' , () => {
 	 	helpModal.dialog("open") ;
 	 })
 	 
 	 //------------ 리셋버튼 이벤트 ---------------
 	 resetBtn.addEventListener('click' , () => {
 		var reDatas = []
 		var proIdInp = document.getElementById('proIdInp') ;
 		var proName  = document.getElementById('proName') ;
 		var proFlag  = document.getElementById('proFlag') ;
 		var manFlag  = document.getElementById('manFlag') ;
 		var proUnit  = document.getElementById('proUnit') ;
 		
 		proIdInp.value = "" ;
 		proName.value  = "" ;
 		proFlag.value  = "" ;
 		manFlag.value  = "" ;
 		proUnit.value  = "" ;
 		
 		MatGrid.resetData(reDatas) ;
 		ProcGrid.resetData(reDatas) ;
		//Grid2.resetOriginData();
 	 })
      
      
    
    </script>
</html>