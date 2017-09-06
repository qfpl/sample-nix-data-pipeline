
This is a simple example of how a data pipeline could be managed with Nix.

The code is dodgy and the examples are contrived, but the data still flows.

We have some posts about using Nix [here](https://blog.qfpl.io/projects/infra/) if you want to learn a bit more about it.

If you are a trusting soul, you could get Nix installed and running pretty quickly with:
```
> sudo mkdir /nix
> sudo chown myuser /nix
> curl https://nixos.org/nix/install | sh
> source ~/.nix-profile/etc/profile.d/nix.sh
```

# How things are organized

We have input data here:

    data/
      in1/
        data.txt
      in2/
        data.txt

and we have programs here:

    programs/
       step1a/
        <python package here> 
       step1b/
        <python package here> 
       step2/
        <python package here> 

The `step1a` program takes an input file and produces an output file containing the contents of the input file in upper case.

The `step1b` program takes an input file and produces an output file containing the contents of the input file interleaved with spaces.

The `step2` program interleaves two input files to produce an output file.

At the moment both the data and the programs are packaged locally.
The proper Nix way to include these pieces would be to put them in git repositories, and to pull them in via the git revision and the hash of the contents.
As a mid-way point between the two, you could set up git repositories in each of the directories for the input data and the programs.

The data pipeline is here:

    pipeline/
      middle1/
        default.nix
      middle2/
        default.nix
      out/
        default.nix

If you just want the output you can do:
```
> cd pipeline/out
> nix-build
```
and you can look at the result with:
```
> cat result/data.txt
```

If you want to look at the intermediate results you can do:
```
> cd pipeline/middle1
> nix-build
```
and can still look at the result with:
```
> cat result/data.txt
```

There is also

    pipeline/
      combined/
        default.nix

which has the whole pipeline in the one file, if that's a style you would prefer.

Doing
```
> cd pipeline/combined
> nix-build
```
and
```
> cat result/data.txt
```
should give you the same results that you got with `pipeline/out`.

# Interesting things to do

This assumes that you have done

```
> cd pipeline/out
> nix-build
...
/nix/store/8hkp04pd932vsphlql8fjw61cr50zj46-out
```

and that you'll be making changes, running `nix-build` again, and then paying attention to

- the console output from Nix, to see what got built
- the contents of `result/data.txt`, to see the effect on the output of the data pipeline

## Run `nix-build` again for fun

If you run it again, it should do nothing an give you the store path to the result:
```
> nix-build
/nix/store/8hkp04pd932vsphlql8fjw61cr50zj46-out
```

That should be expected - nothing in the pipeline has changed, so we don't need to do any work.

If we do
```
> cat result/data.txt
```
we should see that the output is unchanged.

## Change a data file

Edit one of the data files.

I edited `data/in1/data.txt`
```
--- a/data/in1/data.txt
+++ b/data/in1/data.txt
@@ -1,4 +1,4 @@
 Riddle me this, brother can you handle it
 Your style to my style, you can't hold a candle to it
 Equinox symmetry and the balance is right
-Smokin' and drinkin' on a Tuesday night
+Smoking and drinking on a Tuesday night
```
and running `nix-build` yielded this:
```
> nix-build
these derivations will be built:
  /nix/store/d6r21chl4sjyvm2nfpm90vr53dgbi80q-in1.drv
  /nix/store/5g9v6jhphmx270hrhgc9csmd2npq787g-middle1.drv
  /nix/store/1bkavqd7rx66xmv6106fgbqrd9jy8szb-out.drv
building path(s) ‘/nix/store/566parrzs25g9y3cavlvq0b4ylbhgbhd-in1’
installing
building path(s) ‘/nix/store/yrbyjn61yc5bc8fyr6039ri2z2diq9bm-middle1’
building path(s) ‘/nix/store/x5w0vzn7mhpnmnacwylbxwsdgarzpcbs-out’
/nix/store/x5w0vzn7mhpnmnacwylbxwsdgarzpcbs-out
```

We can see that Nix only built the pieces that were effected by the change.

If we do
```
> cat result/data.txt
```
we should see that the output has been changed accordingly.

## Change the data file back

Change the data file back to how it was.

If we run `nix-build` again we get this:
```
> nix-build
/nix/store/8hkp04pd932vsphlql8fjw61cr50zj46-out
```

The Nix store is an append-only, immutable store, and it build things by looking at the hashes of the information required to do the build.
Since we haven't done a garbage collection, it has found something with the same hash in the store and returned the path to it.

Doing
```
> cat result/data.txt
```
will give us our original output, because it was still in the Nix store and didn't even need to be built.

## Change a program

Edit one of the programs.

I edited `programs/step1b/step1b/__init__.py` so that it interleaves " * " between the characters rather than " ".

This is what I got:
```
> nix-build
these derivations will be built:
  /nix/store/i357kycxbpp8ii041hibwfrrxp4knnn3-python3.6-step1b.drv
  /nix/store/smg5s52qsmy80jjxp26zz642563r5val-middle2.drv
  /nix/store/9c4wjf6xs5xyysvi0i0jimdqwszi5y3y-out.drv
building path(s) ‘/nix/store/6pw0w3lzdpjxy7p0wdsrhg2229d9ywlc-python3.6-step1b’
unpacking sources
unpacking source archive /nix/store/hb7zmjkmy58hq04h0z7krrxpidakccnz-step1b
...
python build output
...
building path(s) ‘/nix/store/f5i9j868q56k61652jiv98sqcrkal1az-middle2’
building path(s) ‘/nix/store/h206p5bvfr9jj0rgc413dda3rigln4np-out’
/nix/store/h206p5bvfr9jj0rgc413dda3rigln4np-out
```

Again, we can see that Nix only built the pieces that were effected by the change, and if we do
```
> cat result/data.txt
```
we should see that the output has been changed accordingly.

## Change the program back

Change the program back to how it was.

If we run `nix-build` again we get this:
```
> nix-build
/nix/store/8hkp04pd932vsphlql8fjw61cr50zj46-out
```

We should not be surprised at this point.

Looking at the result of
```
> cat result/data.txt
```
should be similarly boring.
