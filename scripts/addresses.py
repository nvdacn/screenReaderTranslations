# -*- coding: utf-8 -*-
import sys
from subprocess import PIPE, Popen

addresses = {
    'default': {
        'lang': '',
        'email': ['Mesar hameed <mesar.hameed@gmail.com>', 'Rui Batista <ruiandrebatista@gmail.com>'], 
    },
    'am': {
        'lang':'Amharic',
        'email': ['Dr. Tamru E. Belay <g.braille@sympatico.ca>'],
    },
    'an': {
        'lang':'Aragonese',
        'email': ['Jorge Perez <jorgtum@gmail.com>'],
    },
    'ar': { 
        'lang':'Arabic',
        'email': ['Fatma Mehanna <fatma.mehanna@gmail.com>', 'Shaimaa Ibrahim <shamse1@gmail.com>', 'faraz <fawaz.ar94@gmail.com>', 'ruslan <ru2020slan@yandex.ru>'],
    },
    'ar_SO': {
        'lang':'Somalian Arabic',
        'email': ['ahmed alasow <aalasow@talktalk.net>', 'osman <othman82@hotmail.com>'],
    },
    'bg': {
        'lang':'Bulgarian',
        'email': ['Zahari Yurukov <zahari.yurukov@gmail.com>'],
    },
    'cs': {
        'lang': 'Czech',
        'email': ['Radek zalud <radek.zalud@seznam.cz>', 'Martina Letochova <letochova@seznam.cz>'],
    },
    'da': {
        'lang': 'Danish',
        'email': ['Daniel K. Gartmann <kontakt@nvda.dk>', 'Nicolai Svendsen <chojiro1990@gmail.com>', 'bue@vester-andersen.dk'],
    },
    'de': {
        'lang':'German',
        'email': ['Bernd Dorer <bernd_dorer@yahoo.de>', 'David Parduhn <xkill85@gmx.net>', 'Rene Linke <demetry@gmx.de>'],
    },
    'dv': {
        'lang': 'Dhivehi',
        'email': ['Abdulla Shuhood <shuhood@ellygroup.net>'],
    },
    'el': {
        'lang': 'Greek',
        'email': ['access@e-rhetor.com'],
    },
    'es': {
        'lang': 'Spanish',
        'email': ['Juan C. buno <quetzatl@eresmas.net>'],
    },
    'fi': {
        'lang':'Finnish',
        'email': ['Jani Kinnunen <jani.kinnunen@wippies.fi>'],
    }, 
    'fa': {
        'lang':'Farsi',
        'email': ['hamid rezaey <hamidrehzaey@gmail.com>'],
    },
    'fr': {
        'lang':'French',
        'email': ['Michel such <michel.such@free.fr>', 'Patrick ZAJDA <patrick@zajda.fr>'],
    },
    'ga': {
        'lang': 'Gaeilge',
        'email': ['Cearbhall OMeadhra <cearbhall.omeadhra@blbc.ie>', 'Ronan McGuirk <ronan.p.mcguirk@gmail.com>', 'Kevin Scannell <kscanne@gmail.com>'],
    },
    'gl': {
        'lang': 'Galician',
        'email': ['Juan C. buno <quetzatl@eresmas.net>'],
    },
    'hi': {
        'lang': 'Hindi',
        'email': ['dipendra.lists@gmail.com', 'ayeshameshaq@hotmail.com'],
    },
    'hr': {
        'lang': 'Croatian',
        'email': ['Hrvoje Katic <hrvojekatic@gmail.com>', 'Mario Percinic <mario.percinic@gmail.com>'],
    },
    'hu': {
        'lang': 'Hungarian',
        'email': ['Aron OcsvAri <oaron@nvda.hu>'],
    },
    'id': {
        'lang':'Indonesian',
        'email': ['Suratim Amd <suratim@gmail.com>'],
    },
    'is': {
        'lang':'Icelandic',
        'email': ['Birkir R. Gunnarsson <birkir.gunnarsson@gmail.com>', 'Hlynur Hreinsson <hm.hreinsson@gmail.com>'],
    },
    'it': {
        'lang':'Italian',
        'email': ['Simone Dal Maso <simone.dalmaso@juvox.it>'],
    },
    'ja': {
        'lang':'Japanese',
        'email': ['Takuya Nishimoto <nishimotz@gmail.com>'],
    },
    'ko': {
        'lang':'Korean',
        'email': ['Joseph Lee <joseph.lee22590@gmail.com>', 'Chang-Hoan Jang <462356@gmail.com>'],
    },
    'nb_NO': {
        'lang':'Norwegian bokmal',
        'email': ['David Hole <balubathebrave@gmail.com>', 'Bjornar Seppola <bjornar@seppola.net>'],
    },
    'ne': {
        'lang':'Nepali',
        'email': ['him Prasad Gautam <drishtibachak@gmail.com>'],
    },
    'nl': {
        'lang':'Duch',
        'email': ['Bram Duvigneau <bram@bramd.nl>', 'Bart Simons <bart@bartsimons.be>', 'Alwine Hardus <ahardus@xs4all.nl>', 'A Campen <a.campen@wxs.nl>'],
    },
    'nb_NO': {
        'lang':'Norwegian bokmål',
        'email': ['David Hole <balubathebrave@gmail.com>', 'Bjornar Seppola <bjornar@seppola.net>'],
    },
    'pl': {
        'lang':'Polish',
        'email': ['Hubert Meyer <killer@tyflonet.com>'],
    },
    'pt_BR': {
        'lang': 'Brazilian Portuguese',
        'email': ['Cleverson Casarin Uliana <clever92000@yahoo.com.br>', 'Marlin Rodrigues <marlincgrodrigues@yahoo.com.br>'],
    },
    'pt_PT': {
        'lang': 'Portuguese',
        'email': ['Diogo Costa <diogojoca@gmail.com>', 'Rui Batista <ruiandrebatista@gmail.com>', 'Rui Fontes <rui.fontes@tiflotecnia.com>'],
    },
    'ru': {
        'lang': 'Russian',
        'email': ['Beqa Gozalishvili <beqaprogger@gmail.com>', 'ruslan <ru2020slan@yandex.ru>'],
    },
    'si': {
        'lang': 'Sinhala',
        'email': ['Asoka Bandula <asokabandula@gmail.com>'],
    },
    'sk': {
        'lang':'Slovak',
        'email': ['Ondrej Rosik <ondrej.rosik@gmail.com>', 'Peter Vagner <peter.v@datagate.sk>'],
    },
    'sl': {
        'lang':'Slovenian',
        'email': ['Jozko Gregorc <jozko.gregorc@gmail.com>'],
    },
    'sv': {
        'lang':'Swedish',
        'email': ['Mesar Hameed <mhameed@src.gnome.org>'],
    },
    'uk': {
        'lang':'Ukrainian',
        'email': ['Volodymyr Pyrig <vlodko@torba.com>'],
    },
    'ur': {
        'lang':'Urdu',
        'email': ['Rana Ayaz <rana.ayaz1@gmail.com>', 'him Prasad Gautam <drishtibachak@gmail.com>'],
    },
    'ta': {
        'lang':'Tamil',
        'email': ['Dinakar T.D. <td.dinkar@gmail.com>'],
    },
    'tr': {
        'lang':'Turkish',
        'email': ['Cagri Dogan <cagrid@hotmail.com>'],
    },
    'zh_CN': {
        'lang':'Simplified Chinese',
        'email': ['vgjh2005@gmail.com'],
    },
    'zh_HK': {
        'lang': 'Traditional Chinese Hong Kong',
        'email': ['Eric Yip <ericycy@gmail.com>'],
    },
    'zh_TW': {
        'lang': 'Traditional Chinese Taiwan',
        'email': ['wangjanli@gmail.com', 'maro.zhang@gmail.com', 'Aaron Wu <waaron2000@gmail.com>'],
    },
}


def email(rcpts, subject, body):
    rcpts.extend(addresses['default']['email'])
    to = ", ".join(rcpts)
    p1 = Popen(['echo', '-e', body], stdout=PIPE)
    p2 = Popen(['mail', '-s', subject, to], stdin=p1.stdout)


if __name__ == "__main__" and len(sys.argv) >= 2:
    lang = sys.argv[1]
    if not addresses.has_key(lang):
        print "unable to find language: %s" %lang
        sys.exit()
    # we were called from the webhook with lang, subject, body, so send email.
    if len(sys.argv) == 4:
        email(addresses[lang]['email'], sys.argv[2], sys.argv[3])  
    # we were called by another script, with a lang code, spit out email addresses suitable for a commit message.
    elif len(sys.argv) == 2:
        print " \\\n".join([ "--author='%s'" %x for x in addresses[lang]['email']])
    else:
        print "dont know what to do."
