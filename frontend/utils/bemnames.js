import classNames from "classnames";

/* eslint arrow-body-style: ["off"] */
export const createBEM = namespace => {
  return {
    create: blockName => {
      let block = blockName;

      if (typeof namespace === "string") {
        block = `${namespace}-${blockName}`;
      }

      return {
        b: (...more) => {
          return classNames(block, more);
        },
        e: (className, ...more) => {
          return classNames(`${block}__${className}`, more);
        },
        m: (className, ...more) => {
          return classNames(`${block}--${className}`, more);
        }
      };
    }
  };
};

export const bemNames = createBEM("cr");

export default bemNames;
