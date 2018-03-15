# RSpec Notes

Useful tutorials and examples:

* [rspec beginners part 1](https://code.tutsplus.com/articles/rspec-testing-for-beginners-part-1--cms-26716)

* [rspec beginners part 2](https://code.tutsplus.com/articles/rspec-testing-for-beginners-02--cms-26720)

* [rspec beginners part 3](https://code.tutsplus.com/articles/rspec-testing-for-beginners-03--cms-26728)

* [factory_bot part 1](https://code.tutsplus.com/articles/factory-girl-101--cms-25087)

* [factory_bot part 2](https://code.tutsplus.com/articles/factory-girl-201--cms-25171)

* [rspec docs](https://relishapp.com/rspec/)

* [betterspecs](http://www.betterspecs.org/)

Invoking RSpec with `bundle exec` to avoid warnings:

```
% rspec
WARN: Unresolved specs during Gem::Specification.reset:
      minitest (~> 5.1)
      rack-test (>= 0.6.3)
      loofah (~> 2.0)
      nokogiri (>= 1.6)
      erubi (~> 1.4)
      rake (>= 0.8.7)
      thor (< 2.0, >= 0.18.1)
      method_source (>= 0)
      diff-lcs (< 2.0, >= 1.2.0)
WARN: Clearing out unresolved specs.
Please report a bug if this causes problems.
.

Finished in 0.0175 seconds (files took 3.22 seconds to load)
1 example, 0 failures

% bundle exec rspec
.

Finished in 0.02998 seconds (files took 2.17 seconds to load)
1 example, 0 failures
```
