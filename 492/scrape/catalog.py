#!/usr/bin/env python

import sys, re, urllib2
from BeautifulSoup import BeautifulSoup

URL_PAT = 'http://catalog.wwu.edu/ajax/preview_course.php?catoid=6&coid=%s&show'
MIN_ID = 61935
MAX_ID = 65809

def get_soup(url):
    response = urllib2.urlopen(url)
    return BeautifulSoup(response.read())

def get_div(soup):
    return str(soup.findAll('div', {'class': 'ajaxcourseindentfix'})[-1].extract())

def parse_heading(heading_txt):
    pat = r'(.+) (\d+).? - (.+)'
    m = re.match(pat, heading_txt.replace('\n', ''))
    if m is not None:
        return (m.group(1), m.group(2), m.group(3))
    else:
        print 'fail heading'
        
def match(text):
    pat = r'<div class="ajaxcourseindentfix"><h3>([^<]+)</h3>[^<]*<hr />([^<]+)?(<br />)*(<strong>Prerequisites &amp; Notes:</strong>)?[^<]*(<br />)*([^<]+)?(<br />)*Credits: (\d+)'
    m = re.match(pat, text)
    if m is not None:
        section, num, title = parse_heading(m.group(1))
        descr = m.group(2)
        prereqs = m.group(6)
        credits = m.group(8)
        
        descr = descr if descr is not None else ''
        prereqs = prereqs if prereqs is not None else ''
        
        return [section, num, title, descr, prereqs, credits]
    else:
        print 'fail'
        return False
        
    
    
if __name__ == '__main__':
    for line in sys.stdin:
        id = line[:-1]
        try:
            soup = get_soup(URL_PAT % id)
            text = get_div(soup)
            attrs = match(text)
            if not attrs:
                print text
                exit()
                pass
            print '"%s"' % '", "'.join(attrs)
        except:
            print 'ERROR 500 on id=%s' % id
                
