(local {: autoload} (require "nfnl.module"))
(local core (autoload "nfnl.core"))
(local {: split : join} (autoload "nfnl.string"))

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

(fn upper-case-first-letter [str] (str:gsub "^%l" string.upper))

(fn upper-case [index]
  (func (fn [[[arg]]]
          (upper-case-first-letter arg)) [index]))

(fn tag [name]
  [(text (.. "<" name ">"))
   (choice 1
           [(sn nil [(insert 1)])
            (sn nil [(text ["" "  "]) (insert 1) (text ["" ""])])])
   (text (.. "</" name ">"))
   (insert 0)])

(fn filename-without-extension []
  (vim.fn.expand "%:t:r"))

(fn kebab-to-pascal-case [str]
  (->> (split str "-")
       (core.map upper-case-first-letter)
       (join)))

(local all {:date [(func (fn [] (os.date "%Y-%m-%d")))]
            :time [(func (fn [] (os.date "%H:%M")))]})

(local fennel
       {:core [(text ["(local {: autoload} (require \"nfnl.module\"))"
                      "(local core (autoload \"nfnl.core\"))"])]})

(local typescriptreact {:l (fmt "{}"
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
                        :copy (fmt "navigator.clipboard.writeText(JSON.stringify({}, null, 2)).then(() => console.log('Text copied to clipboard', JSON.stringify({}, null, 2)))"
                                   [(insert 1) (rep 1)])
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
                        :prejson (fmt "<pre onClick={{() => {{ navigator.clipboard.writeText(JSON.stringify({}, null, 2)).then(() => alert('Copied to clipboard!')).catch(err => console.error('Failed to copy:', err)) }}}} style={{{{ color: '#333', backgroundColor: '#efefef', padding: '10px', margin: '10px', border: '1px solid #ccc', cursor: 'pointer' }}}}> {{ JSON.stringify({}, null, 2) }}</pre>"
                                      [(insert 1) (rep 1)])
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
                        :table (tag "table")
                        :thead (tag "thead")
                        :tbody (tag "tbody")
                        :tr (tag "tr")
                        :th (tag "th")
                        :td (tag "td")
                        :span (tag "span")
                        :label (tag "label")
                        :form (tag "form")
                        :imp (fmt "import {} from '{}'"
                                  [(choice 1
                                           [(insert 1)
                                            (fmt "{{ {} }}" [(insert 1)])])
                                   (insert 2)])
                        :c (fmt "className={}{}"
                                [(choice 1
                                         [(fmt "'{}'" [(insert 1)])
                                          (fmt "{{{}}}" [(insert 1)])])
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
                              (insert 0)]
                        :comp [(text "export default function ")
                               (func #(kebab-to-pascal-case (filename-without-extension)))
                               (text "(")
                               (choice 1
                                       [(text " ") (fmt "{{ {} }}" (insert 1))])
                               (text [") {" "  return (" "    "])
                               (choice 2
                                       [(func #(.. "<div data-component='"
                                                   (kebab-to-pascal-case (filename-without-extension))
                                                   "'>"
                                                   (kebab-to-pascal-case (filename-without-extension))
                                                   "</div>"))
                                        (text "")])
                               (text ["" "  )" "}"])]
                        "todo:" (text "TODO: ")})

(local filetype-snippets {: all : fennel : typescriptreact})

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

; TODO: make this work:
;
; (local s ls.snippet)
; (local t ls.text_node)
; (local i ls.insert_node)
; (local f ls.function_node)
;
; (fn add-import [symbol-name module-name]
;   (fn []
;     (let [buf (vim.api.nvim_get_current_buf)
;           lines (vim.api.nvim_buf_get_lines buf 0 -1 false)]
;       ;; Check if symbol is already imported
;       (var already-imported false)
;       (each [_ line (ipairs lines)]
;         (when (line:match (.. "import.*{.*" symbol-name ".*}.*from.*['\"]"
;                               module-name "['\"]"))
;           (set already-imported true)))
;       (if already-imported
;           ""
;           ;; Already imported
;           (do
;             ;; Look for existing import from the same module
;             (var found-existing false)
;             (each [i line (ipairs lines) &until found-existing]
;               (let [existing-import (line:match (.. "import%s*{([^}]*)}%s*from%s*['\"]"
;                                                     module-name "['\"]"))]
;                 (when existing-import
;                   ;; Add to existing import
;                   (let [new-import (.. (existing-import:gsub "%s*$" "") ", "
;                                        symbol-name)
;                         new-line (line:gsub "{[^}]*}" (.. "{" new-import "}"))]
;                     (vim.api.nvim_buf_set_lines buf (- i 1) i false [new-line])
;                     (set found-existing true)))))
;             (when (not found-existing)
;               ;; No existing import, create new one
;               (var insert-line 0)
;               (each [i line (ipairs lines)]
;                 (if (line:match "^import") (set insert-line i)
;                     (and (not (line:match "^import"))
;                          (not (line:match "^%s*$")) (not (line:match "^//"))) (lua "break")))
;               (let [import-statement (.. "import { " symbol-name " } from '"
;                                          module-name "';")]
;                 (vim.api.nvim_buf_set_lines buf insert-line insert-line false
;                                             [import-statement])))
;             "")))))
;
; ;; React snippets with smart imports
; (s "ue" [(f (add-import "useEffect" "react"))
;          (t "useEffect(() => {")
;          (t ["" "  "])
;          (i 1)
;          (t ["" "}, ["])
;          (i 2)
;          (t "])")
;          (i 0)])
;
; (s "us"
;    [(f (add-import "useState" "react" (t "const [") (i 1 "state")
;                          (t ", set") (f (fn [args]
;                                          (-> (. args 1 1)
;                                              (: "gsub" "^%l" string.upper)))
;                                        [1])
;                          (t "] = useState(") (i 2) (t ")") (i 0)))])
;
; ;; Additional React hooks
; (s "uc" [(f (add-import "useCallback" "react" (t "useCallback(() => {")
;                               (t ["" "  "]) (i 1) (t ["" "}, ["]) (i 2) (t "])")
;                               (i 0)))])
;
; (s "um" [(f (add-import "useMemo" "react"))
;          (t "useMemo(() => {")
;          (t ["" "  return "])
;          (i 1 (t ["" "}, ["]) (i 2) (t "])") (i 0))])
;
; (s "ur" [(f (add-import "useRef" "react"))
;          (t "const ")
;          (i 1 "ref")
;          (t " = useRef(")
;          (i 2 (t ")") (i 0))])

{: setup}
