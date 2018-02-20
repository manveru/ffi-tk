{
  ast = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pp82blr5fakdk27d1d21xq9zchzb6vmyb1zcsl520s3ygvprn8m";
      type = "gem";
    };
    version = "2.3.0";
  };
  bacon = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f06gdj77bmwzc1k5iragl1595hbn67yc7sqvs56ca8plrr2vmai";
      type = "gem";
    };
    version = "1.2.0";
  };
  coderay = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15vav4bhcc2x3jmi3izb11l4d9f3xv8hp2fszb7iqmpsccv1pz4y";
      type = "gem";
    };
    version = "1.1.2";
  };
  docile = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m8j31whq7bm5ljgmsrlfkiqvacrw6iz9wq10r3gwrv5785y8gjx";
      type = "gem";
    };
    version = "1.1.5";
  };
  ffi = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nkcrmxqr0vb1y4rwliclwlj2ajsi4ddpdx2gvzjy0xbkk5iqzfp";
      type = "gem";
    };
    version = "1.9.14";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lhinj9vj7mw59jqid0bjn2hlfcnq02bnvsx9iv81nl2han603s0";
      type = "gem";
    };
    version = "2.0.2";
  };
  method_source = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xqj21j3vfq4ldia6i2akhn2qd84m0iqcnsl49kfpq3xk6x0dzgn";
      type = "gem";
    };
    version = "0.9.0";
  };
  parser = {
    dependencies = ["ast"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nply96nqrkgx8d3jay31sfy5p4q74dg8ymln0mdazxx5cz2n8bq";
      type = "gem";
    };
    version = "2.3.3.1";
  };
  powerpack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fnn3fli5wkzyjl4ryh0k90316shqjfnhydmc7f8lqpi0q21va43";
      type = "gem";
    };
    version = "0.1.1";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mh312k3y94sj0pi160wpia0ps8f4kmzvm505i6bvwynfdh7v30g";
      type = "gem";
    };
    version = "0.11.3";
  };
  rainbow = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0frz90gyi5k26jx3ham1x661hpkxf82rkxb85nakcz70dna7i8ri";
      type = "gem";
    };
    version = "2.2.1";
  };
  rubocop = {
    dependencies = ["parser" "powerpack" "rainbow" "ruby-progressbar" "unicode-display_width"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0604qa0s0xcq0avnh9aa6iw58azpz6a7bavcs0ch61xnaz0qfl0c";
      type = "gem";
    };
    version = "0.46.0";
  };
  ruby-progressbar = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qzc7s7r21bd7ah06kskajc2bjzkr9y0v5q48y0xwh2l55axgplm";
      type = "gem";
    };
    version = "1.8.1";
  };
  simplecov = {
    dependencies = ["docile" "json" "simplecov-html"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ffhyrfnq2zm2mc1742a4hqy475g3qa1zf6yfldwg1ldh5sn3qbx";
      type = "gem";
    };
    version = "0.12.0";
  };
  simplecov-html = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qni8g0xxglkx25w54qcfbi4wjkpvmb28cb7rj5zk3iqynjcdrqf";
      type = "gem";
    };
    version = "0.10.0";
  };
  unicode-display_width = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lfkyv3c6nyy96jv8wvy33x6g1gmigbm1ficpb2mzhyk07assrnr";
      type = "gem";
    };
    version = "1.1.2";
  };
}