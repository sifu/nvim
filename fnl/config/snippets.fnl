(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))
(local ls (require "luasnip"))
(local fmt (. (require "luasnip.extras.fmt") "fmt"))
(local rep (. (require "luasnip.extras") "rep"))

(local snip ls.snippet)
(local text ls.text_node)
(local insert ls.insert_node)
(local func ls.function_node)
(local choice ls.choice_node)
(local sn ls.sn)

(var state {:counter 0})
(fn here-counter []
  (func (fn []
          (tset state "counter" (+ 1 (. state "counter")))
          (tostring (. state "counter")))))

(fn upper-case [index]
  (func (fn [[[arg]]]
          (arg:gsub "^%l" string.upper)) [index]))

(fn tag [name]
  [(text (.. "<" name ">"))
   (choice 1
           [(sn nil [(insert 1)])
            (sn nil [(text ["" "  "]) (insert 1) (text ["" ""])])])
   (text (.. "</" name ">"))
   (insert 0)])

(local all {:date [(func (fn [] (os.date "%Y-%m-%d")))]
            :time [(func (fn [] (os.date "%H:%M")))]})

(local fennel
       {:core [(text ["(local {: autoload} (require \"nfnl.module\"))"
                      "(local core (autoload \"nfnl.core\"))"])]})

(local javascript {:l (fmt "{}"
                           [(choice 1
                                    [(fmt "console.log('%c log ', 'background: #222; color: #bada55; padding: 2px', {})"
                                          [(insert 1)])
                                     (fmt "console.log('%c log ', 'background: #222; color: #bada55; padding: 2px', JSON.stringify({}, null, 2))"
                                          [(insert 1)])])])
                   :ll (fmt "{}"
                            [(choice 1
                                     [(fmt "console.log('%c {} ', 'background: #222; color: #bada55; padding: 2px', {})"
                                           [(insert 1) (rep 1)])
                                      (fmt "console.log('%c {} ', 'background: #222; color: #bada55; padding: 2px', JSON.stringify({},null, 2))"
                                           [(insert 1) (rep 1)])])])
                   "{l" (fmt "{}"
                             [(choice 1
                                      [(fmt "{{ console.log('%c log ', 'background: #222; color: #bada55; padding: 2px', {}) }}"
                                            [(insert 1)])
                                       (fmt "{{ console.log('%c log ', 'background: #222; color: #bada55; padding: 2px', JSON.stringify({}, null, 2)) }}"
                                            [(insert 1)])])])
                   "{ll" (fmt "{}"
                              [(choice 1
                                       [(fmt "{{ console.log('%c {} ', 'background: #222; color: #bada55; padding: 2px', {}) }}"
                                             [(insert 1) (rep 1)])
                                        (fmt "{{ console.log('%c {} ', 'background: #222; color: #bada55; padding: 2px', JSON.stringify({}, null, 2)) }}"
                                             [(insert 1) (rep 1)])])])
                   :.thenlog (text ".then( result => {console.log(result);return result})")
                   :css (fmt "{}"
                             [(choice 1
                                      [(fmt "import {} from 'styles/{}.module.css'"
                                            [(insert 1) (rep 1)])
                                       (fmt "import {} from './{}.module.css'"
                                            [(insert 1) (rep 1)])])])
                   :descibe (fmt "describe( '{}', () => {{\n  {}\n}})"
                                 [(insert 1) (insert 2)])
                   :expect (fmt "expect({}).toEqual({})"
                                [(insert 1) (insert 2)])
                   :it (fmt "it( 'should {}', () => {{\n  {}\n}})"
                            [(insert 1) (insert 2)])
                   :ihtml (fmt "dangerouslySetInnerHTML={{{{__html: {}}}}}"
                               [(insert 1)])
                   :json (fmt "JSON.stringify({}, null, 2)" [(insert 1)])
                   :prejson (fmt "<pre style={{{{ color: '#333', backgroundColor: '#efefef', padding: '10px', margin: '10px', border: '1px solid #ccc' }}}}>{{ JSON.stringify({}, null, 2)}}</pre>"
                                 [(insert 1)])
                   :useEffect (fmt "useEffect(( ) => {{\n  {}\n}}, [{}])"
                                   [(insert 2) (insert 1)])
                   :ue (fmt "useEffect(( ) => {{\n  {}\n}}, [{}])"
                            [(insert 2) (insert 1)])
                   :h (fmt "console.log('--- {} ---')" [(here-counter)])
                   :us (fmt "const [{}, set{}] = useState({})"
                            [(insert 1) (upper-case 1) (insert 0)])
                   :useState (fmt "const [{}, set{}] = useState({})"
                                  [(insert 1) (upper-case 1) (insert 0)])
                   :p (tag "p")
                   :div (tag "div")
                   :html (tag "html")
                   :head (tag "head")
                   :title (tag "title")
                   :body (tag "body")
                   :article (tag "article")
                   :section (tag "section")
                   :aside (tag "aside")
                   :button (tag "button")
                   :h1 (tag "h1")
                   :h2 (tag "h2")
                   :h3 (tag "h3")
                   :h4 (tag "h4")
                   :h5 (tag "h5")
                   :h6 (tag "h6")
                   :hgroup (tag "hgroup")
                   :header (tag "header")
                   :pre (tag "pre")
                   :blockquote (tag "blockquote")
                   :ol (tag "ol")
                   :ul (tag "ul")
                   :li (tag "li")
                   :i (tag "i")
                   :strong (tag "strong")
                   :b (tag "b")
                   :imp (fmt "import {} from '{}'"
                             [(choice 1
                                      [(insert 1)
                                       (fmt "{{ {} }}" [(insert 1)])])
                              (insert 2)])
                   :c (fmt "className={}{}"
                           [(choice 1
                                    [(fmt "{{{}}}" [(insert 1)])
                                     (fmt "'{}'" [(insert 1)])])
                            (insert 0)])
                   :fun [(text "const ")
                         (insert 1 "name")
                         (text " = ")
                         (choice 2
                                 [(sn nil (insert 1))
                                  (text "( )")
                                  (fmt "( {} )" (insert 1))
                                  (fmt "( {{ {} }})" (insert 1))])
                         (text " => ")
                         (choice 3
                                 [(sn nil [(insert 1)])
                                  (fmt "(\n  {}\n)" (insert 1))
                                  (fmt "{{\n  return (\n    {}\n  )\n}}"
                                       (insert 1))])
                         (insert 0)]})

;   comp = {
;           text("export default function "),
;           func(function()
;                return dash_to_mixed_case(filename_without_extension())
;                end),
;           text("("),
;           choice(1, {
;                      text(" "),
;                      fmt("{{ {} }}", insert(1)),})
;           ,
;           text({ ") {", "  return (", "    " }),
;           choice(2, {
;                      func(function()
;                           return "<div>" .. dash_to_mixed_case(filename_without_extension()) .. "</div>"
;                           end),
;                      text(""),})
;           ,
;           text({ "", "  )", "}" }),
;           },
;   a = fmt( -- TODO: allow plain <a> by using match to check if <a{}> is preciding and not expanding a another time
;           "<a href={}>{}</a>",
;           {
;            choice(1, {
;                       fmt("'{}'", { insert(1) }),
;                       fmt("{{{}}}", { insert(1) }),})
;            ,
;            insert(0),})
;
;   ,
;   link = fmt( -- TODO: allow plain <a> by using match to check if <a{}> is preciding and not expanding a another time
;              "<Link href={}>{}</Link>",
;              {
;               choice(1, {
;                          fmt("{{{}}}", { insert(1) }),
;                          fmt("'{}'", { insert(1) }),})
;               ,
;               insert(0),})
;
;   ,

(local filetype-snippets {: all : fennel : javascript})

(fn dict->snippet-table [dict]
  (let [result []]
    (each [k v (pairs dict)]
      (table.insert result (snip {:trig k} v)))
    result))

(fn map-value [f dict]
  (let [result {}]
    (each [k v (pairs dict)] (core.assoc result k (f v)))
    result))

(fn setup []
  (ls.add_snippets nil (map-value dict->snippet-table filetype-snippets)))

{: setup}
