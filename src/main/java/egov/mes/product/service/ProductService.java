package egov.mes.product.service;

import java.util.List;

import egov.mes.product.dao.ProductVO;

public interface ProductService {
	List<ProductVO> podtList(ProductVO product) ;
	List<ProductVO> findProduct(ProductVO product) ;
	void insertInOut(ProductVO product) ;
	void updateLotno(ProductVO product) ;
	void deleteInOut(ProductVO product) ;
}