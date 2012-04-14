#!/usr/bin/env python

import sys, re, urllib2
from BeautifulSoup import BeautifulSoup

URL_PAT = 'http://catalog.wwu.edu/content.php?catoid=6&navoid=617&filter%%5Bitem_type%%5D=3&filter%%5Bonly_active%%5D=1&filter%%5B3%%5D=1&filter%%5Bcpage%%5D=%s#acalog_template_course_filter'
MIN_ID = 1
MAX_ID = 35

def get_soup(url):
    response = urllib2.urlopen(url)
    return BeautifulSoup(response.read())

def get_ids(soup):
    td = soup.find('td', {'class': 'block_content'})
    tbl = td.findAll('table')[-1]
    links = tbl.findAll('a')
    pat = re.compile(r'.*coid=(\d+)')
    ids = []
    for link in links:
        m = pat.match(link['href'])
        if m is not None:
            ids.append(m.group(1))
            
    return ids
        
if __name__ == '__main__':
    for n in xrange(MIN_ID, MAX_ID):
        soup = get_soup(URL_PAT % n)
        ids = get_ids(soup)
        for id in ids:
            print id
            
