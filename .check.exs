[
  fix: true,
  tools: [
    # basic
    {:compiler, false},
    {:formatter, true},
    {:unused_deps, true},

    # checks
    {:credo, false},
    {:ex_doc, true},

    # disabled
    {:dialyzer, false},
    {:ex_unit, false},
    {:npm_test, false}
  ]
]
