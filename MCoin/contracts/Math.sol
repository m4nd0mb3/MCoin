//CdBy mand0mb3
pragma solidity >=0.4.22 <0.9.0;

library base{

    function _add( uint256 a, uint256 b) external pure  returns(uint256 sum){
        assembly{
            sum :=add(a,b)
        }
    }
    function _sub( uint256 a, uint256 b) external pure  returns(uint256 result){
        assert(a>=b);
        assembly{
            result :=sub(a,b)
        }
    }

}