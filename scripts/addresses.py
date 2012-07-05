# -*- coding: utf-8 -*-
import sys
from subprocess import PIPE, Popen

addresses = {
    'default': {
        'lang': '',
        'email': ['Mesar hameed <mesar.hameed@gmail.com>'], 
    },
    'am': {
        'lang':'Amharic',
        'email': ['Dr. Tamru E. Belay <g.braille@sympatico.ca>', 'Adanech Berehe <snderelae@yahoo.com>'],
    },
    'ar': { 
        'lang':'Arabic',
        'email': ['Fatma Mehanna <fatma.mehanna@gmail.com>'],
    },
    'bg': {
        'lang':'Bulgarian',
        'email': ['Zahari Yurukov <zahari.yurukov@gmail.com>'],
    },
    'cs': {
        'lang': 'Czech',
        'email': ['Radek zalud <radek.zalud@seznam.cz>'],
    },
    'da': {
        'lang': 'Danish',
        'email': ['Daniel K. Gartmann <kontakt@nvda.dk>'],
    },
    'de': {
        'lang':'German',
        'email': ['Bernd Dorer <bernd_dorer@yahoo.de>', 'David Parduhn <xkill85@gmx.net>', 'Rene Linke <rene.linke@blindzeln.de>'],
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
    'fr': {
        'lang':'French',
        'email': ['Michel such <michel.such@free.fr>', 'Patrick ZAJDA <patrick@zajda.fr>'],
    },
    'gl': {
        'lang': 'Galician',
        'email': ['Juan C. buno <quetzatl@eresmas.net>'],
    },
    'hr': {
        'lang': 'Croatian',
        'email': ['Hrvoje Katic <hrvojekatic@gmail.com>', 'Mario Percinic <mario.percinic@gmail.com>'],
    },
    'hu': {
        'lang': 'Hungarian',
        'email': ['Aron OcsvAri <oaron1@gmail.com>'],
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
        'email': ['Joseph Lee <joseph.lee22590@gmail.com>'],
    },
    'nb_NO': {
        'lang':'Norwegian bokmål',
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
        'email': ['Diogo Costa <diogojoca@gmail.com>', 'Rui Batista <ruiandrebatista@gmail.com>'],
    },
'sk': {
        'lang':'Slovak',
        'email': ['Ondrej Rosik <ondrej.rosik@gmail.com>', 'Peter Vagner <peter.v@datagate.sk>'],
    },
    'sv': {
        'lang':'Swedish',
        'email': ['Mesar Hameed <mhameed@src.gnome.org>'],
    },
    'uk': {
        'lang':'Ukrainian',
        'email': ['vlodko@torba.com'],
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
        'email': ['qt06.com@139.com'],
    },
    'zh_HK': {
        'lang': 'Traditional Chinese Hong Kong',
        'email': ['Eric Yip <ericycy@gmail.com>'],
    },
    'zh_TW': {
        'lang': 'Traditional Chinese Taiwan',
        'email': ['wangjanli@gmail.com', 'maro.zhang@gmail.com', 'Aaron Wu <waaron2000@gmail.com>'],
    },
    'promotion': {
        'lang': '',
        'email': ['james.homme@highmark.com'],
    },
}

vocAddresses = []
for key in addresses:
    vocAddresses.extend(addresses[key]['email'])

addresses['vocalizer'] = { 'lang': '', 'email': vocAddresses}


def email(rcpts, subject, body):
    rcpts.extend(addresses['default']['email'])
    to = ", ".join(rcpts)
    p1 = Popen(['echo', '-e', body], stdout=PIPE)
    p2 = Popen(['mail', '-s', subject, to], stdin=p1.stdout)


if __name__ == "__main__" and len(sys.argv) == 4:
    lang = sys.argv[1]
    if not addresses.has_key(lang):
        print "unable to find language: %s" %lang
        sys.exit()
    email(addresses[lang]['email'], sys.argv[2], sys.argv[3])  
