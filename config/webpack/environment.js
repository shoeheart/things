const { environment } = require("@rails/webpacker");
// not automatically added by rails webpacker:install:erb so erb is not defined
// const erb = require("./loaders/erb");

// erb parser doesn't have all runtime context available and
// throws parser errors so webpacker doesn't get right result
// which is ok since we don't want webpacker packing these files
// into stuff sent to browser anyway.  Better would be to have
// webpacker ignore .erb files?
// environment.loaders.append('erb', erb)
module.exports = environment;
