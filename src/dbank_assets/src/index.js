import { dbank } from '../../declarations/dbank'

async function updateBalance() {
  const balanceSpan = document.getElementById('value');
  const balance = await dbank.checkBalance();
  balanceSpan.innerText = balance.toFixed(2);
}

window.addEventListener('load', updateBalance)

document.querySelector('form').addEventListener('submit', async (event) => {
  // console.log(event)
  event.preventDefault();
  const button = event.target.querySelector('#submit-btn');
  button.setAttribute('disabled', true);

  const inputAmount = parseFloat(event.target[0].value);
  const withdrawAmount = parseFloat(event.target[1].value);
  const outputs = [];
  if (inputAmount) outputs.push(await dbank.topUp(inputAmount))
  if (withdrawAmount) outputs.push(await dbank.withdraw(withdrawAmount))

  await dbank.compound();
  updateBalance();
  button.removeAttribute('disabled');
  document.getElementById('withdrawal-amount').value = "";
  document.getElementById('input-amount').value = "";
  console.log(inputAmount, withdrawAmount, outputs);
})