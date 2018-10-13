import random from "faker/lib/random";

const randomNum = (min = 0, max = 1000) => random().number({ min, max });
export default randomNum;
