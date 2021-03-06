package egov.mes.resources.rtngd.dao;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class ResourcesRtngdVO {
		String rtngdNo;		//반품번호
		String rscTstNo;	//자재입고검사번호
		String rscCode;		//자재코드
		String rtngdCnt;	//반품량
		String defCode;		//불량코드
		
		String defName;		//불량이름
		String rscName;		//자재명
		String rscUnit;		//자재단위
		
		String rscTotal;	//합계
		String rscPrc;		//단가
		
		String sucName;
		String sucCode;
		@DateTimeFormat(pattern = "yyyy-MM-dd")
		@JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
		String rtngdDate;
		@DateTimeFormat(pattern = "yyyy-MM-dd")
		@JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
		String rtngdDate2;
		
		
		
}
