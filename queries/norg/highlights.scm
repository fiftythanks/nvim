;; extends

((verbatim) @markup.verbatim.link
            (#has-ancestor? @markup.verbatim.link link_description)
            (#set! priority 150))
