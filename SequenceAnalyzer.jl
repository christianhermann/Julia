using Pkg
using Gtk
using CSV
using DataFrames
using DataFramesMeta
using Gadfly




function readFasta(filePath)
    textArray = String[]
    f = open(filePath,"r") 
    for line in eachline(f)
        push!(textArray,line)
    end
    close(f)
   # seqName, seq
    return(textArray)
end

function splitCodons(seq, seqLength)
   codons = String[]
   k = 1
    for i in [1:3:seqLength;]
        push!(codons,seq[i:i+2])
        k = k + 1
    end
return(codons)
end


function translateCodons(codonSeq, codonTable)
    translatedCodon =  codonTable[(codonTable.codon .== codonSeq),1][1]
    return(translatedCodon)
end

function getBasePercentage(seq, seqLength)
   As = count(i->(i=='A'), seq)
   Cs = count(i->(i=='C'), seq)
   Gs = count(i->(i=='G'), seq)
   Ts = count(i->(i=='T'), seq)

   as = count(i->(i=='a'), seq)
   cs = count(i->(i=='c'), seq)
   gs = count(i->(i=='g'), seq)
   ts = count(i->(i=='t'), seq)

   compAs = As + as
   compCs = Cs + cs
   compGs = Gs + gs
   compTs = Ts + ts

   percentageAs = (compAs / seqLength) * 100
   percentageCs = (compCs / seqLength) * 100
   percentageGs = (compGs / seqLength) * 100
   percentageTs = (compTs / seqLength) * 100

   df = DataFrame(
       Base = ["A","C","G","T"],
       Amount =[compAs, compCs, compGs, compTs],
       Percentage = [percentageAs,percentageCs,percentageGs,percentageTs]
   )
   return(df)
end

function getAminoAcidPercentage(translatedCodons)
    translatedCodonsLength = length(translatedCodons)
    aminoAcids = ["A","R","N","D","C","Q","E","G","H","I", "L","K","M","F","P","S","T","W","Y","V"]
    percentageAAs =  map(aminoAcids) do x
     (count(i->(i==x), translatedCodons) / translatedCodonsLength) *100
    end
    df = DataFrame(AminoAcid = aminoAcids, Percentage = percentageAAs)
    return(df)
end

filePath = open_dialog("Pick a file")
readData = readFasta(filePath)

filePathCodons =  open_dialog("Pick a file")
codonTable = CSV.read(filePathCodons,DataFrame)
#seqName= split(readData[1], "|")[3]
seqName = readData[1]
popfirst!(readData)
seq = join(readData)
seqLength = length(seq)
codons = splitCodons(seq, seqLength-2)

translatedCodons = map(x -> translateCodons(x, codonTable), codons)


baseOccurance = getBasePercentage(seq, seqLength)
plot(baseOccurance, x=:Base, y=:Percentage,  color =:Base,Geom.bar, Theme(bar_spacing=5mm))


aminoAcidOccurance = getAminoAcidPercentage(translatedCodons)
plot(aminoAcidOccurance, x=:AminoAcid, y=:Percentage, Geom.bar, Theme(bar_spacing=5mm))
