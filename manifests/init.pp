class  swap {
    exec { "create swap file":
      command => "/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024",
      creates => "/var/swap.1",
    }

    exec { "attach swap file":
      command => "/sbin/mkswap /var/swap.1 && /sbin/swapon /var/swap.1",
      require => Exec["create swap file"],
      unless => "/sbin/swapon -s | grep /var/swap.1",
    }

    rclocal::script { "activate_swap":
        priority => "10",
        content  => '#!/bin/bash
SWAP=`/sbin/swapon -s | wc -l`
if [[ $SWAP -gt 1 ]]; then
  /sbin/mkswap /var/swap.1 && /sbin/swapon /var/swap.1
fi

'
    }
}

