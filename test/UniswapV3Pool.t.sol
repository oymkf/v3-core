pragma solidity >=0.7.0;
pragma abicoder v2;

import "forge-std/Test.sol";
import "./ERC20Mintable.sol";
import "../src/UniswapV3Factory.sol";
import "../src/UniswapV3PoolDeployer.sol";

contract UniswapV3PoolTest is Test {
    ERC20Mintable weth;
    ERC20Mintable usdt;
    UniswapV3Factory factory;
    UniswapV3PoolDeployer deployer;

    function setUp() public {
        weth = new ERC20Mintable("Ether", "WETH", 18);
        usdt = new ERC20Mintable("USDT", "USDT", 18);
        factory = new UniswapV3Factory();
        deployer = new UniswapV3PoolDeployer();
    }

    function testMint() public {
        weth.mint(address(this), 1000 ether);
        usdt.mint(address(this), 10000000 ether);

        assertEq(weth.balanceOf(address(this)), 1000 ether);
        assertEq(usdt.balanceOf(address(this)), 10000000 ether);
    }

    function testCreatePool() public {
        address poolAddress = factory.createPool(
            address(weth),
            address(usdt),
            500
        );
    }
}
