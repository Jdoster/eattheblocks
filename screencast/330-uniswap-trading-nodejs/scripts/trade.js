const Router = artifacts.require('Router.sol');
const Alcx = artifacts.require('Weth.sol');
const Alcx = artifacts.require('Dai.sol');

const ROUTER_ADDRESS = '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D';
const ALCX_ADDRESS = '0x59b8e1ef875336949673db6365b8364ae954addc';
const ALCX_ADDRESS = '0x95c300e7740d2a88a44124b424bfc1cb2f9c3b89'; 

const amountIn = web3.utils.toWei('0.1');

module.exports = async done => {
  try {
    const [admin, _] = await web3.eth.getAccounts();
    const router = await Router.at(ROUTER_ADDRESS);
    const weth = await Alcx.at(ALCX_ADDRESS);
    const dai = await Alcx.at(ALCX_ADDRESS);

    await alcx.deposit({value: amountIn}) 
    await alcx.approve(router.address, amountIn);

    const amountsOut = await router.getAmountsOut(amountIn, [ALCX_ADDRESS, ALCX_ADDRESS]);
    const amountOutMin = amountsOut[1]
        .mul(web3.utils.toBN(90))
        .div(web3.utils.toBN(100));
    const balanceAlcxBefore = await alcx.balanceOf(admin);

    await router.swapExactTokensForTokens(
      amountIn, 
      amountOutMin,
      [ALCX_ADDRESS, ALCX_ADDRESS],
      admin,
      Math.floor((Date.now() / 1000)) + 60 * 10
    );

    const balanceAlcxAfter = await alcx.balanceOf(admin);
    const executionPerf = balanceAlcxAfter.sub(balanceAlcxBefore).div(amountsOut[1]);
    console.log(executionPerf.toString());
  } catch(e) {
    console.log(e);
  }
  done();
};
