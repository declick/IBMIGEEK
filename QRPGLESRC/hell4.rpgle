      * HELL4 - Ask a name and say hello (RPG IV)
     DNAME             S             10A
     DMSG              S             20A
      /FREE
       DSPLY 'NAME ?' ' ' NAME;
       Msg = 'HELLO ' + %TRIM(Name);
       DSPLY Msg;
       *INLR = *ON;
      /END-FREE
