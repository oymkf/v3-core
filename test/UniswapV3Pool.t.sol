pragma solidity >=0.7.0;
pragma abicoder v2;

import "forge-std/Test.sol";
import "./ERC20Mintable.sol";
import "../src/UniswapV3Factory.sol";
import "../src/UniswapV3PoolDeployer.sol";
import "../src/interfaces/IUniswapV3Pool.sol";

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

        IUniswapV3Pool pool = IUniswapV3Pool(poolAddress);

        assertEq(
            factory.getPool(address(weth), address(usdt), 500),
            poolAddress,
            "invalid pool address in the registry"
        );

        assertEq(
            factory.getPool(address(usdt), address(weth), 500),
            poolAddress,
            "invalid token0 address in the pool"
        );

        assertEq(pool.factory(), address(factory), "invalid factory address");
        assertEq(pool.token0(), address(usdt), "invalid weth address");
        assertEq(pool.token1(), address(weth), "invalid usdt address");

        // pool.initialize(5000 << 96);
        (
            uint160 sqrtPriceX96,
            int24 tick,
            uint16 observationIndex,
            uint16 observationCardinality,
            uint16 observationCardinalityNext,
            uint8 feeProtocol,
            bool unlocked
        ) = pool.slot0();

        assertEq(uint256(sqrtPriceX96), uint256(0), "invalid sqrtPriceX96");
        assertEq(int256(tick), 0, "invalid tick");
        assertEq(uint256(observationIndex), 0, "invalid observationIndex");
        assertEq(
            uint256(observationCardinality),
            0,
            "invalid observationCardinality"
        );
        assertEq(
            uint256(observationCardinalityNext),
            0,
            "invalid observationCardinalityNext"
        );
        assertEq(uint256(feeProtocol), 0, "invalid feeProtocol");
        assertEq(unlocked, false, "invalid unlocked");
    }
}
