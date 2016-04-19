# DBConsistencyCheck
CMS DBS vs PhEDEx database consistency check

## Project description
The Data bookkeeping system (DBS) and data location system (PhEDEx)
are two most populated databases in CMS experiment. Both contains
a meta-data information about CMS data, such as dataset, block, file information.
The former is a meta-data catalog of the data produced in CMS, the latter
is a catalog of data placement. The data are stored in those DBs
by different data operation teams using various tools. Therefore it is
possible that data may be inconsistent between the two databases.
You'll develop tools which will allow to check the content of two databases
and make a visual (web-based) representation of such differences.
We need to compare the following information:

- dataset exists both in PhEDEx and DBS [*]
- dataset has same blocks in PhEDEx and DBS
- For each block in dataset:
  - Block has same files (LFNs) in PhEDEx and DBS
  - Block is in same open/closed status in PhEDEx and DBS [**]
  - For each file in block:
    - File has same size in PhEDEx and DBS
    - File has same checksums in PhEDEx and DBS

Things to be careful about in checking:
[*] - Check only datasets/blocks/files older than 1 day
[*] - Ignore test datasets which may be allowed to be inconsistent (need to define list of test datasets...)
[**] - We have only closed blocks in DBS; so in practice we just need to 
check that blocks are closed in PhEDEx in a reasonable time (less than 1
day from end of file injections)

The data from DBS will be fetched via DBS APIs, while the data from PhEDEx
is already available on HDFS. We'll need to write a python script to
extract DBS data and store it to HDFS. Then we need to write an additional
script to compare data on HDFS for DBS and PhEDEx. Finally, your task will be
to develop simple web pages to visualize the difference.

The tasks should be organized to run as cronjobs that we'll be able to
perform periodic checks.

Tools to review:
- python language
- HDFS, spark

### PhEDEx data are on HDFS:/project/awg/cms/phedex/catalog/csv
```
  hadoop fs -ls /project/awg/cms/phedex/catalog/csv
```

Here is an example of rows from HDFS
```
/QCD/v1/AODSIM,845055,y,1459821572.83263,/QCD/v1/AODSIM#123,6371058,1459881399.10162,n,/store/lfn.root,87425713,2852194134,"adler32:3aa28be9,cksum:808021722",1459894243.63832
```

### DBS data
DBS data are available via [DBS APIs](https://cms-http-group.web.cern.ch/cms-http-group/apidoc/dbs3-client/current/dbs.apis.html)

#### How to run DBS client on lxplus:
```
  scramv1 project CMSSW CMSSW_8_0_4
  cd CMSSW_8_0_4/
  cmsenv
  source /cvmfs/cms.cern.ch/crab3/crab.sh
  voms-proxy-init -rfc -voms cms
```

Example of dbs_client.py script, we'll use the following procedure:

1 fetch all datasets from DBS (it should yield around 100k datasets)
2 loop over all datasets and get list of blocks (should retrieve closed blocks ~O(1M) in about 5-6h)
  - get block attributes
3 loop over all blocks and get list of files for individual block (should retrieve
  around O(10M) files in about 27hours)
  - get file attributes

This will create an initial copy of the data and we'll store it to HDFS.
Then we'll use a timestamp to fetch newer datasets and repeat steps #2 and #3
to get newer list of blocks/files on periodic basis.

Example of dbs client script:
``` 
#!/usr/bin/env python
from __future__ import print_function, division

# system modules
import os
import sys
import time

# DBS modules
from dbs.apis.dbsClient import DbsApi

def client():
    url = 'https://cmsweb.cern.ch/dbs/prod/global/DBSReader'
    dbsclient = DbsApi(url)
    min_cdate = 1460000000 # some time stamp
    time0 = time.time()
    datasets = dbsclient.listDatasets(min_cdate=min_cdate)
    print("listDatasets time:", time.time()-time0)
    print("# datasets", len(datasets))

    dataset = '/ZMM_14TeV/Summer12-DESIGN42_V17_SLHCTk-v1/GEN-SIM'
    time0 = time.time()
    blocks = dbsclient.listBlocks(dataset=dataset, detail=True)
    for blk in blocks:
        print(blk['block_name'],blk['block_size'],blk['file_count'])
    print("listBlocks time:", time.time()-time0)

    # get files for given block
    time0 = time.time()
    blk = '/ZMM_14TeV/Summer12-DESIGN42_V17_SLHCTk-v1/GEN-SIM#f7d604e6-5e87-11e1-a77d-003048f0e7dc'
    files = dbsclient.listFiles(block_name=blk, validFileOnly=1, detail=True)
    for lfn in files:
        print(lfn['logical_file_name'],lfn['check_sum'],lfn['file_size'])
    print("listBlocks time:", time.time()-time0)

def main():
    "Main function"
    client()

if __name__ == '__main__':
    main()
```

Example of DBS data:

```
./dbs_client.py
listDatasets time: 0.532593011856
# datasets 2272
/ZMM_14TeV/Summer12-DESIGN42_V17_SLHCTk-v1/GEN-SIM#f7d604e6-5e87-11e1-a77d-003048f0e7dc 2488909525 1
/ZMM_14TeV/Summer12-DESIGN42_V17_SLHCTk-v1/GEN-SIM#d702c5de-5f53-11e1-a77d-003048f0e7dc 1936668367 1
/ZMM_14TeV/Summer12-DESIGN42_V17_SLHCTk-v1/GEN-SIM#ccf74e52-61c4-11e1-a77d-003048f0e7dc 628209051 1
/ZMM_14TeV/Summer12-DESIGN42_V17_SLHCTk-v1/GEN-SIM#86fb3df4-60c1-11e1-a77d-003048f0e7dc 1217339580 1
listBlocks time: 0.0101478099823
/store/mc/Summer12/ZMM_14TeV/GEN-SIM/DESIGN42_V17_SLHCTk-v1/0000/EE8A7288-865E-E111-A0BC-00266CFAE684.root 1025833106 2488909525
listBlocks time: 0.0118079185486
```

## References
The CMS Data Management System 
M. Giffels, Y. Guo, V. Kuznetsov, N. Magini and T. Wildish J. Phys.: Conf. Ser. 513 042052 doi:10.1088/1742-6596/513/4/042052, http://iopscience.iop.org/article/10.1088/1742-6596/513/4/042052/pdf
