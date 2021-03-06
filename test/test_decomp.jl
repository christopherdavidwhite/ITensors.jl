using ITensors, Test

a = [-0.1, -0.12]
@test ITensors.truncate!(a) == (0., 0.)
@test length(a) == 1
a = [0.1, 0.01, 1e-13]
@test ITensors.truncate!(a,absoluteCutoff=true,cutoff=1e-5) == (1e-13, (0.01 + 1e-13)/2)
@test length(a) == 2

i = Index(2,"i")
j = Index(2,"j")
A = randomITensor(i,j)
@test_throws ArgumentError factorize(A, i, dir="fakedir")


@testset "Spectrum" begin
  i = Index(100,"i")
  j = Index(100,"j")

  U,S,V = svd(rand(100,100))
  S ./= norm(S)
  A = ITensor(U*diagm(0=>S)*V', i,j)

  spec = svd(A,i).spec

  @test eigs(spec) ≈ S .^2
  @test truncerror(spec) == 0.0

  spec = svd(A,i; maxdim=length(S)-3).spec
  @test truncerror(spec) ≈ sum(S[end-2:end].^2)

end
