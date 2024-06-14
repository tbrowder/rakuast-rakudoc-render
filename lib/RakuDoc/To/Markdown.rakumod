use experimental :rakuast;
use RakuDoc::Render;
use RakuDoc::PromiseStrings;

unit class RakuDoc::To::Markdown;

method render($ast) {
say 'program ', $*PROGRAM, ' args ', @*ARGS;
    my $rdp = RakuDoc::Processor.new;
    $rdp.add-templates( $.markdown-templates, :source<RakuDoc::To::MarkDown> );
    $rdp.render( $ast[0] )
}

# no post processing needed
method postprocess( $final ) { $final };

method markdown-templates {
    my constant RESET = "\e[0m";
    my constant BOLD-ON = "\e[1m";
    my constant BOLD-OFF = "\e[22m";
    my constant ITALIC-ON = "\e[3m";
    my constant ITALIC-OFF = "\e[23m";
    my constant UNDERLINE-ON = "\e[4m";
    my constant UNDERLINE-OFF = "\e[24m";
    my constant DBL-UNDERLINE-ON = "\e[21m";
    my constant DBL-UNDERLINE-OFF = "\e[24m";
    my constant CURL-UNDERLINE-ON = "\e[4:3m";
    my constant CURL-UNDERLINE-OFF = "\e[4:0m";
    my constant BLINK-ON = "\e[5m";
    my constant BLINK-OFF = "\e[25m";
    my constant INDEXED-ON = "\e[7m";
    my constant INDEXED-OFF = "\e[27m";
    my constant CODE-ON = "\e[7m";
    my constant CODE-OFF = "\e[27m";
    my constant STRIKE-ON = "\e[9m";
    my constant STRIKE-OFF = "\e[29m";
    my constant SUPERSCR-ON = "\e[48;5;78m\e[73m";
    my constant SUBSCR-ON = "\e[48;5;80m\e[74m";
    my constant SUBSCR-OFF = "\e[75m\e[39;49m";
    my constant SUPERSCR-OFF = "\e[75m\e[39;49m";
    my constant INDEX-ENTRY-ON = "\e[48;5;2m";
    my constant INDEX-ENTRY-OFF = "\e[39;49m";
    my constant KEYBOARD-ON = "\e[48;5;5m";
    my constant KEYBOARD-OFF = "\e[39;49m";
    my constant TERMINAL-ON = "\e[48;5;6m";
    my constant TERMINAL-OFF = "\e[39;49m";
    my constant FOOTNOTE-ON = "\e[48;5;214m\e[38;5;0m";
    my constant FOOTNOTE-OFF = "\e[39;49m";
    my constant LINK-TEXT-ON = "\e[48;5;227m\e[38;5;0m";
    my constant LINK-TEXT-OFF = "\e[39;49m";
    my constant LINK-ON = "\e[38;5;227m\e[48;5;0m";
    my constant LINK-OFF = "\e[39;49m";
    my constant DEPR-TEXT-ON = "\e[48;5;216m\e[38;5;0m";
    my constant DEPR-TEXT-OFF = "\e[39;49m";
    my constant DEPR-ON = "\e[38;5;196m\e[48;5;0m";
    my constant DEPR-OFF = "\e[39;49m";
    my constant DEFN-TEXT-ON = "\e[38;5;197m\e[48;5;0m";
    my constant DEFN-TEXT-OFF = "\e[39;49m";
    my @bullets = <<\x2219 \x2022 \x25b9 \x2023 \x2043>> ;
    %(
        #| special key to name template set
        _name => -> %, $ { 'markdown templates' },
        #| renders =code blocks
        code => -> %prm, $tmpl {
            my $del = '';
            if %prm<delta> {
                $del = DEPR-TEXT-ON ~ %prm<delta>[1] ~ DEPR-TEXT-OFF ~ " for " ~ DEPR-ON ~ %prm<delta>[0] ~ DEPR-OFF ~ "\n\n"
            }
            PStr.new: $del ~ "\n  --- code --- \n"
            ~ %prm<contents>
            ~ "\n  --- ----- ---\n"
        },
        #| renders implicit code from an indented paragraph
        implicit-code => -> %prm, $tmpl {
            my $del = '';
            if %prm<delta> {
                $del = DEPR-TEXT-ON ~ %prm<delta>[1] ~ DEPR-TEXT-OFF ~ " for " ~ DEPR-ON ~ %prm<delta>[0] ~ DEPR-OFF ~ "\n\n"
            }
            PStr.new: $del ~ %prm<delta> ~ "\n  --- code --- \n"
            ~ %prm<contents>
            ~ "\n  --- ----- ---\n"
        },
        #| renders =input block
        input => -> %prm, $tmpl {
            my $del = '';
            if %prm<delta> {
                $del = DEPR-TEXT-ON ~ %prm<delta>[1] ~ DEPR-TEXT-OFF ~ " for " ~ DEPR-ON ~ %prm<delta>[0] ~ DEPR-OFF ~ "\n\n"
            }
            PStr.new: $del ~ "\n  --- input --- \n"
            ~ %prm<contents>
            ~ "\n  --- ------ ---\n"
        },
        #| renders =output block
        output => -> %prm, $tmpl {
            my $del = '';
            if %prm<delta> {
                $del = DEPR-TEXT-ON ~ %prm<delta>[1] ~ DEPR-TEXT-OFF ~ " for " ~ DEPR-ON ~ %prm<delta>[0] ~ DEPR-OFF ~ "\n\n"
            }
            PStr.new: $del ~ "\n  --- output --- \n"
            ~ %prm<contents>
            ~ "\n  --- ------ ---\n"
         },
        #| renders =comment block
        comment => -> %prm, $tmpl { '' },
        #| renders =formula block
        formula => -> %prm, $tmpl {
            my $indent = %prm<level> > 5 ?? 4 !! (%prm<level> - 1) * 2;
            my $del = '';
            if %prm<delta> {
                $del = DEPR-TEXT-ON ~ %prm<delta>[1] ~ DEPR-TEXT-OFF ~ " for " ~ DEPR-ON ~ %prm<delta>[0] ~ DEPR-OFF ~ "\n\n"
            }
            "\n\n" ~ %prm<delta> ~ ' ' x $indent  ~ DBL-UNDERLINE-ON ~ %prm<caption> ~  DBL-UNDERLINE-OFF ~ "\n\n" ~
            $del ~ %prm<formula> ~ "\n\n"
        },
        #| renders =head block
        head => -> %prm, $tmpl {
            my $indent = %prm<level> > 5 ?? 4 !! (%prm<level> - 1) * 2;
            my $del = "\n";
            if %prm<delta> {
                $del = DEPR-TEXT-ON ~ %prm<delta>[1] ~ DEPR-TEXT-OFF ~ " for " ~ DEPR-ON ~ %prm<delta>[0] ~ DEPR-OFF ~ "\n\n"
            }
            "\n\n" ~ ' ' x $indent  ~ DBL-UNDERLINE-ON ~ BOLD-ON ~ %prm<contents> ~ BOLD-OFF ~ DBL-UNDERLINE-OFF ~
            "\n" ~ $del
        },
        #| renders =numhead block
        numhead => -> %prm, $tmpl {
            my $del = "\n";
            if %prm<delta> {
                $del = DEPR-TEXT-ON ~ %prm<delta>[1] ~ DEPR-TEXT-OFF ~ " for " ~ DEPR-ON ~ %prm<delta>[0] ~ DEPR-OFF ~ "\n\n"
            }
            my $indent = %prm<level> > 5 ?? 4 !! (%prm<level> - 1) * 2;
            my $title = %prm<numeration> ~ ' ' ~ %prm<contents>;
            "\n\n" ~ ' ' x $indent ~ DBL-UNDERLINE-ON ~ BOLD-ON ~ $title ~ BOLD-OFF ~  DBL-UNDERLINE-OFF ~
            "\n" ~ $del
        },
        #| renders the numeration part for a toc
        toc-numeration => -> %prm, $tmpl { %prm<contents> },
        #| renders =defn block
        defn => -> %prm, $tmpl {
            BOLD-ON ~ %prm<term> ~ BOLD-OFF ~ "\n" ~
            "\t" ~ %prm<contents> ~ "\n"
        },
        #| renders =numdefn block
        #| special template to render a defn list data structure
        defn-list => -> %prm, $tmpl { "\n" ~ [~] %prm<defn-list> },
        #| special template to render a numbered defn list data structure
        numdefn => -> %prm, $tmpl {
            BOLD-ON ~ %prm<numeration> ~ ' ' ~ %prm<term> ~ BOLD-OFF ~ "\n" ~
            "\t" ~ %prm<contents> ~ "\n"
        },
        #| special template to render a numbered item list data structure
        numdefn-list => -> %prm, $tmpl { "\n" ~ [~] %prm<numdefn-list> },
        #| renders =item block
        item => -> %prm, $tmpl {
            my $num = %prm<level> - 1;
            $num = @bullets.elems - 1 if $num >= @bullets.elems;
            my $bullet = %prm<bullet> // @bullets[ $num ];
            $bullet ~ ' ' ~ %prm<contents> ~ "\n"
        },
        #| special template to render an item list data structure
        item-list => -> %prm, $tmpl {
            "\n" ~ [~] %prm<item-list>
        },
        #| renders =numitem block
        numitem => -> %prm, $tmpl {
            %prm<numeration> ~ ' ' ~ %prm<contents> ~ "\n"
        },
        #| special template to render a numbered item list data structure
        numitem-list => -> %prm, $tmpl {
            "\n" ~ [~] %prm<numitem-list>
        },
        #| renders =nested block
        nested => -> %prm, $tmpl {
            PStr.new: "\t" ~ %prm<contents> ~ "\n\n"
        },
        #| renders =para block
        para => -> %prm, $tmpl { %prm<contents> ~ "\n\n" },
        #| renders =place block
        place => -> %prm, $tmpl {
            my $del = '';
            if %prm<delta> {
                $del = DEPR-TEXT-ON ~ %prm<delta>[1] ~ DEPR-TEXT-OFF ~ " for " ~ DEPR-ON ~ %prm<delta>[0] ~ DEPR-OFF ~ "\n"
            }
            my $rv = PStr.new;
            $rv ~= $del;
            $rv ~= %prm<contents> ;
            $rv ~= "\n\n";
        },
        #| renders =rakudoc block
        rakudoc => -> %prm, $tmpl { %prm<contents> ~ "\n" }, #pass through without change
        #| renders =section block
        section => -> %prm, $tmpl {
            my $del = '';
            if %prm<delta> {
                $del = DEPR-TEXT-ON ~ %prm<delta>[1] ~ DEPR-TEXT-OFF ~ " for " ~ DEPR-ON ~ %prm<delta>[0] ~ DEPR-OFF ~ "\n"
            }
            $del ~ %prm<contents> ~ "\n"
        },
        #| renders =SEMANTIC block, if not otherwise given
        semantic => -> %prm, $tmpl {
            my $indent = %prm<level> > 5 ?? 4 !! (%prm<level> - 1) * 2;
            my $del = '';
            if %prm<delta> {
                $del = DEPR-TEXT-ON ~ %prm<delta>[1] ~ DEPR-TEXT-OFF ~ " for " ~ DEPR-ON ~ %prm<delta>[0] ~ DEPR-OFF ~ "\n"
            }
            "\n\n" ~ ' ' x $indent  ~ DBL-UNDERLINE-ON ~ BOLD-ON ~ %prm<caption> ~ BOLD-OFF ~ DBL-UNDERLINE-OFF ~ "\n" ~
            $del ~
            %prm<contents> ~"\n\n"
        },
        #| renders =pod block
        pod => -> %prm, $tmpl { %prm<contents> },
        #| renders =table block
        table => -> %prm, $tmpl {
            my $del = '';
            if %prm<delta> {
                $del = DEPR-TEXT-ON ~ %prm<delta>[1] ~ DEPR-TEXT-OFF ~ " for " ~ DEPR-ON ~ %prm<delta>[0] ~ DEPR-OFF ~ "\n"
            }
            if %prm<procedural> {
                # calculate column widths naively, will include possible markup, and
                # will fail if embedded tables
                # TODO comply with justification, now right-justify col-head, top-justify row labels.
                my @col-wids;
                my $wid;
                for %prm<grid>.list -> @row {
                    for @row.kv -> $n, %cell {
                        next if %cell<no-cell>;
                        $wid = %cell<data>.Str.chars + 2;
                        @col-wids[$n] = $wid if $wid > (@col-wids[$n] // 0)
                    }
                }
                my $table-wid = (+@col-wids * 3) + 4 + [+] @col-wids;
                my @rendered-grid;
                my $col-count;
                for %prm<grid>.kv -> $r, @row {
                    $col-count = 0;
                    for @row.kv -> $n, %cell {
                        next if %cell<no-cell>;
                        my $data = %cell<data>.Str;
                        my $chars = $data.subst(/ "\x1B".+?'m' /,'',:g).chars;
                        my $col-wid = @col-wids[$n];
                        if %cell<span>:exists {
                            #for the col-span
                            if %cell<span>[0] > 1 {
                                for ^( %cell<span>[0] - 1) {
                                    $col-wid += @col-wids[ $n + $_ + 1] + 2
                                }
                            }
                            #for the row-span
                            if %cell<span>[1] > 1 {
                                for ^ (%cell<span>[1] - 1 ) {
                                    @rendered-grid[$r + $_ + 1][$n] ~= ' ' x $col-wid ~ ' |'
                                }
                            }
                        }
                        my $pref = ( $col-wid - $chars ) div 2;
                        my $post = $col-wid - $pref - $chars;
                        @rendered-grid[ $r ][ $n ] ~=
                            ' ' x $pref ~
                            (%cell<header> || %cell<label> ?? BOLD-ON !! '') ~
                            $data ~
                            (%cell<header> || %cell<label> ?? BOLD-OFF !! '')
                            ~ ' ' x $post ~ ' |';
                    }
                }
                my $cap-shift = ( $table-wid - %prm<caption>.chars ) div 2;
                my $row-shift = $cap-shift <= 0 ?? - $cap-shift !! 0;
                $cap-shift = 0 if $cap-shift <= 0;
                PStr.new: $del ~
                    "\n" ~ ' ' x $cap-shift ~ DBL-UNDERLINE-ON ~ %prm<caption> ~ DBL-UNDERLINE-OFF ~"\n" ~
                    @rendered-grid.map({
                    ' ' x $row-shift ~ '| ' ~ $_.grep( *.isa(Str) ).join('') ~ "\n"
                    }).join('') ~ "\n\n"
               ;
            }
            else {
                my $cap-shift = (([+] %prm<headers>[0]>>.Str>>.chars) + (3 * +%prm<headers>[0]) + 4 - %prm<caption>.chars ) div 2;
                my $row-shift = $cap-shift <= 0 ?? - $cap-shift !! 0;
                $cap-shift = 0 if $cap-shift <= 0;
                PStr.new: $del ~ "\n" ~
                    ' ' x $cap-shift ~
                    DBL-UNDERLINE-ON ~ %prm<caption> ~ DBL-UNDERLINE-OFF ~"\n" ~
                    ' ' x $row-shift ~
                    '| ' ~ BOLD-ON ~ %prm<headers>[0].join( BOLD-OFF ~ ' | ' ~ BOLD-ON ) ~ BOLD-OFF ~ " |\n" ~
                    %prm<rows>.map({
                        ' ' x $row-shift ~
                        '| ' ~ $_.join(' | ') ~ " |\n"
                    }).join('') ~ "\n\n"
            }
        },
        #| renders =custom block
        custom => -> %prm, $tmpl {
            my $del = '';
            if %prm<delta> {
                $del = DEPR-TEXT-ON ~ %prm<delta>[1] ~ DEPR-TEXT-OFF ~ " for " ~ DEPR-ON ~ %prm<delta>[0] ~ DEPR-OFF ~ "\n"
            }
            PStr.new: DBL-UNDERLINE-ON ~ %prm<caption> ~ DBL-UNDERLINE-OFF ~ "\n" ~
            $del ~
            %prm<raw> ~ "\n\n"
        },
        #| renders any unknown block minimally
        unknown => -> %prm, $tmpl {
            PStr.new: DBL-UNDERLINE-ON ~ 'UNKNOWN' ~ DBL-UNDERLINE-OFF ~
            %prm<contents> ~ "\n\n"
        },
        #| special template to encapsulate all the output to save to a file
        final => -> %prm, $tmpl {
            'This is a markup render' ~
            ( %prm<rendered-toc> ??
                ( %prm<rendered-toc> ~ "\n" ~ '=' x (%*ENV<WIDTH> // 80) ~ "\n")
                !! ''
            ) ~
            "\n" ~ CURL-UNDERLINE-ON ~ %prm<title> ~ CURL-UNDERLINE-OFF ~ "\n\n" ~
            (%prm<subtitle> ?? ( %prm<subtitle> ~ "\n\n" ~ ('-' x (%*ENV<WIDTH> // 80) ) ~ "\n\n") !! '') ~
            %prm<body>.Str ~ "\n" ~
            %prm<footnotes>.Str ~ "\n" ~
            ( %prm<rendered-index>
                ?? ( "\n\n" ~ '=' x (%*ENV<WIDTH> // 80) ~ "\n" ~ %prm<rendered-index> ~ "\n" )
                !! ''
            ) ~
            "\x203b" x ( %*ENV<WIDTH> // 80 ) ~
            "\nRendered from " ~ %prm<source-data><path> ~ '/' ~ %prm<source-data><name> ~
            (sprintf( "at %02d:%02d UTC on %s", .hour, .minute, .yyyy-mm-dd) with %prm<modified>.DateTime) ~
            "\nSource last modified " ~ (sprintf( "at %02d:%02d UTC on %s", .hour, .minute, .yyyy-mm-dd) with %prm<source-data><modified>.DateTime) ~
            "\n\n" ~
            (( "\x203b" x ( %*ENV<WIDTH> // 80 ) ~ "\n" ~ %prm<warnings> ) if %prm<warnings>)
        },
        #| renders a single item in the toc
        toc-item => -> %prm, $tmpl {
            my $pref = ' ' x ( %prm<toc-entry><level> > 4 ?? 4 !! (%prm<toc-entry><level> - 1) * 2 )
                ~ (%prm<toc-entry><level> > 1 ?? '- ' !! '');
            PStr.new: $pref ~ %prm<toc-entry><caption> ~ "\n"
        },
        #| special template to render the toc list
        toc => -> %prm, $tmpl {
            PStr.new: DBL-UNDERLINE-ON ~ %prm<caption> ~ DBL-UNDERLINE-OFF ~ "\n" ~
            ([~] %prm<toc-list>) ~ "\n\n"
        },
        #| renders a single item in the index
        index-item => -> %prm, $tmpl {
            sub si( %h, $n ) {
                my $rv = '';
                for %h.sort( *.key )>>.kv -> ( $k, %v ) {
                    $rv ~= "\t" x $n ~ "- $k : see in"
                        ~ %v<refs>.map({ ' § ' ~ .<place> }).join(',')
                        ~ "\n"
                        ~ si( %v<sub-index>, $n + 1 );
                }
                $rv
            }
            PStr.new: INDEX-ENTRY-ON ~ %prm<entry> ~ INDEX-ENTRY-OFF ~ ': see in'
                ~ %prm<entry-data><refs>.map({ ' § ' ~ .<place> }).join(',')
                ~ "\n"
                ~ si( %prm<entry-data><sub-index>, 1 );
        },
        #| special template to render the index data structure
        index => -> %prm, $tmpl {
            PStr.new: DBL-UNDERLINE-ON ~ %prm<caption> ~ DBL-UNDERLINE-OFF ~"\n" ~
            ([~] %prm<index-list>) ~ "\n\n"
        },
        #| special template to render the footnotes data structure
        footnotes => -> %prm, $tmpl {
            if %prm<footnotes>.elems {
            PStr.new: "\n" ~ DBL-UNDERLINE-ON ~ 'Footnotes' ~ DBL-UNDERLINE-OFF ~ "\n" ~
                %prm<footnotes>.map({
                    FOOTNOTE-ON ~ $_.<fnNumber> ~ FOOTNOTE-OFF ~ '. ' ~ $_.<contents>.Str
                }).join("\n") ~ "\n\n"
            }
            else { '' }
        },
        #| special template to render the warnings data structure
        warnings => -> %prm, $tmpl {
            if %prm<warnings>.elems {
                PStr.new: DBL-UNDERLINE-ON ~ 'WARNINGS' ~ DBL-UNDERLINE-OFF ~ "\n" ~
                %prm<warnings>.kv.map({ $^a + 1 ~ ": $^b" }).join("\n") ~ "\n\n"
            }
            else { '' }
        },
        ## Markup codes with only display (format codes), no meta data allowed
        ## meta data via Config is allowed
        #| B< DISPLAY-TEXT >
        #| Basis/focus of sentence (typically rendered bold)
        markup-B => -> %prm, $ {
            BOLD-ON ~ %prm<contents> ~ BOLD-OFF
        },
        #| C< DISPLAY-TEXT >
        #| Code (typically rendered fixed-width)
        markup-C => -> %prm, $tmpl { CODE-ON ~ %prm<contents> ~ CODE-OFF },
        #| H< DISPLAY-TEXT >
        #| High text (typically rendered superscript)
        markup-H => -> %prm, $tmpl { SUPERSCR-ON ~ %prm<contents> ~ SUPERSCR-OFF },
        #| I< DISPLAY-TEXT >
        #| Important (typically rendered in italics)
        markup-I => -> %prm, $tmpl { ITALIC-ON ~ %prm<contents> ~ ITALIC-OFF },
        #| J< DISPLAY-TEXT >
        #| Junior text (typically rendered subscript)
        markup-J => -> %prm, $tmpl { SUBSCR-ON ~ %prm<contents> ~ SUBSCR-OFF },
        #| K< DISPLAY-TEXT >
        #| Keyboard input (typically rendered fixed-width)
        markup-K => -> %prm, $tmpl { KEYBOARD-ON ~ %prm<contents> ~ KEYBOARD-OFF },
        #| N< DISPLAY-TEXT >
        #| Note (text not rendered inline, but visible in some way: footnote, sidenote, pop-up, etc.))
        markup-N => -> %prm, $tmpl {
            PStr.new: FOOTNOTE-ON ~ '[ ' ~ %prm<fnNumber> ~ ' ]' ~ FOOTNOTE-OFF
        },
        #| O< DISPLAY-TEXT >
        #| Overstrike or strikethrough
        markup-O => -> %prm, $tmpl { STRIKE-ON ~ %prm<contents> ~ STRIKE-OFF },
        #| R< DISPLAY-TEXT >
        #| Replaceable component or metasyntax
        markup-R => -> %prm, $tmpl { BLINK-ON ~ %prm<contents> ~ BLINK-OFF },
        #| S< DISPLAY-TEXT >
        #| Space characters to be preserved
        markup-S => -> %prm, $tmpl { %prm<contents> },
        #| T< DISPLAY-TEXT >
        #| Terminal output (typically rendered fixed-width)
        markup-T => -> %prm, $tmpl { TERMINAL-ON ~ %prm<contents> ~ TERMINAL-OFF },
        #| U< DISPLAY-TEXT >
        #| Unusual (typically rendered with underlining)
        markup-U => -> %prm, $tmpl { UNDERLINE-ON ~ %prm<contents> ~ UNDERLINE-OFF },
        #| V< DISPLAY-TEXT >
        #| Verbatim (internal markup instructions ignored)
        markup-V => -> %prm, $tmpl { %prm<contents> },

        ##| Markup codes, optional display and meta data

        #| A< DISPLAY-TEXT |  METADATA = ALIAS-NAME >
        #| Alias to be replaced by contents of specified V<=alias> directive
        markup-A => -> %prm, $tmpl { %prm<contents> },
        #| E< DISPLAY-TEXT |  METADATA = HTML/UNICODE-ENTITIES >
        #| Entity (HTML or Unicode) description ( E<entity1;entity2; multi,glyph;...> )
        markup-E => -> %prm, $tmpl { %prm<contents> },
        #| F< DISPLAY-TEXT |  METADATA = LATEX-FORM >
        #| Formula inline content ( F<ALT|LaTex notation> )
        markup-F => -> %prm, $tmpl { CODE-ON ~ %prm<formula> ~ CODE-OFF },
        #| L< DISPLAY-TEXT |  METADATA = TARGET-URI >
        #| Link ( L<display text|destination URI> )
        markup-L => -> %prm, $tmpl {
            LINK-TEXT-ON ~ %prm<link-label> ~ LINK-TEXT-OFF ~
            '[' ~
            ( given %prm<type> {
                when 'internal' { 'this page: ' }
                when 'external' { 'internet location: ' }
                when 'local' { 'this location (site): ' }
            } ) ~
            LINK-ON ~ %prm<target> ~ LINK-OFF ~
            ']'
         },
        #| P< DISPLAY-TEXT |  METADATA = REPLACEMENT-URI >
        #| Placement link
        markup-P => -> %prm, $tmpl {
            given %prm<schema> {
                when 'defn' {
                    BOLD-ON ~ %prm<contents> ~ BOLD-OFF ~ "\n\x29DB" ~
                    DEFN-TEXT-ON ~ %prm<defn-expansion> ~ DEFN-TEXT-OFF ~
                    "\n\x29DA"
                }
                default { %prm<contents> }
            }
        },

        ##| Markup codes, mandatory display and meta data
        #| D< DISPLAY-TEXT |  METADATA = SYNONYMS >
        #| Definition inline ( D<term being defined|synonym1; synonym2> )
        markup-D => -> %prm, $tmpl {  BOLD-ON ~ %prm<contents> ~ BOLD-OFF },
        #| Δ< DISPLAY-TEXT |  METADATA = VERSION-ETC >
        #| Delta note ( Δ<visible text|version; Notification text> )
        markup-Δ => -> %prm, $tmpl {
            DEPR-TEXT-ON ~ %prm<meta> ~ DEPR-TEXT-OFF ~
            '[ for ' ~ DEPR-ON ~ %prm<contents> ~ DEPR-OFF ~ ']'
        },
        #| M< DISPLAY-TEXT |  METADATA = WHATEVER >
        #| Markup extra ( M<display text|functionality;param,sub-type;...>)
        markup-M => -> %prm, $tmpl { CODE-ON ~ %prm<contents> ~ CODE-OFF },
        #| X< DISPLAY-TEXT |  METADATA = INDEX-ENTRY >
        #| Index entry ( X<display text|entry,subentry;...>)
        markup-X => -> %prm, $tmpl { INDEXED-ON ~ %prm<contents> ~ INDEXED-OFF },
        #| Unknown markup, render minimally
        markup-unknown => -> %prm, $tmpl { CODE-ON ~ %prm<contents> ~ CODE-OFF },
    ); # END OF TEMPLATES (this comment is to simplify documentation generation)
}