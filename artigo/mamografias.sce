/*
2   Extração do contorno e suavização
    
  A abordagem de segmentação utilizada nessa seção é baseada sobre
limite local adaptativo usando tabelas de soma(?) implementadas 
através do conceito de imagens integrais. O paragrafo seguinte descreve
o método.

    2.1 Limite local adaptativo para segmentação utilizando tabelas
  de soma
  
      Dada uma imagem na qual a intensidade de um pixel está na posi
    ção (i,j). Na técnica de limite local adaptativo, o objetivo
    é calcular um limite T(i,j) para cada pixel, da seguinte maneira:
    
        se I(i,j) <= T(i,j)
            O(i,j) = 0 (PRETO)
        senão                                                      (1)
            O(i,j) = 255 (BRANCO)

    onde O(i,j) é a imagem de saída e I(i,j) é a imagem de entrada.
      
      A técnica de segmentação binária de Sauvola calcula o limite
    local T(i,j) de um pixel centrado numa janela WxW usando a média
    local m(i,j) e o desvio padrão local s(i,j). A expressão usada no 
    método de segmentação binária de Sauvola é da forma:
    
        T(i,j) = m(i,j)[1+k{(s(i,j)/R)-1}]                         (2)
        
    onde R é o valor máximo do desvio padrão e k é o parâmetro que toma
    valores positivos no intervalo [0.2,0.5].
      
      O uso de desvio padrão nessa fórmula tem como intuito adaptar o 
    limite ao valor do pixel na janela. Quando o contraste na regi
    ão é alto, s(i,j) é praticamente igual a R que fará com que os va
    lores em T(i,j) serão praticamente iguais a m(i,j). Caso contrário,
    na região uniforme o desvio padrão é baixo e o limite fica abai
    xo da média local, assim removendo com sucesso a região relativa
    mente escura do fundo.
    
      Calculando a equação (2) para uma imagem com dimensões NxN resulta
    numa complexidade computacional de O(W²N²)(EXPONENCIAL) o que faz 
    o método consumir muito tempo. Essa complexidade pode ser reduzida 
    para O(N²)(QUADRÁTICA) usando o conceito de imagem integral. Uma
    imagem integral é definida como a imagem na qual a intensidade de
    um pixel numa dada posição é igual à soma de todos os pixels acima
    e aqueles as esquerda da posição. A expressão da imagem integral é
    da forma:
    
        Is(i,j) = EE I(k,l)                                        (3)
                  ^^(Somatórios de k=0 até i e l=0 até j)

      A média local e a variância podem ser calculadas de maneira efi
    ciente para qualquer tamanho de janela usando uma soma e duas sub
    trações em vez de somar todos os pixels da dada janela. A média
    local m(i,j) é definida como segue:
    
        m(i,j) = Is(i+w/2,j+w/2) + Is(i-w/2,j-w/2)
               - Is(i+w/2,j-w/2) - Is(i-w/2,j+w/2)                 (4)

      O desvio padrão s(i,j) é definido como segue:
      
        s²(i,j) = 1/w² EE I²(k,l)-m²(i,j)                          (5)
                       ^^(Somatórios com k=i-w/2 até i+w/2 
                                         l=j-w/2 até j+w/2 )

      O resultado da segmentação binária das mamografias usando essa
    abordagem está presente na figura 1.
      
      Depois da segmentação, pontos ruidosos ao longo do contorno são
    removidos usando uma dilação seguida por uma erosão (1C). Essas du
    as operações são realizadas para evitar qualquer deslocamento da
    fronteira.
      
      A figura 2 mostra algumas mamografias contendo bastante ruído 
    de fundo. Após a segmentação binária, a fronteira da mama na mamo
    grafia não é totalmente recuperável com o método de limite global,
    enquanto que com o método de limite local permite recuperação total
    após operações morfológicas (erosão e dilatação) com uma estrutura
    7x7.
    
      Esses dois casos de mamografias representados na figura 2 são uma
    boa ilustração de que o método do limite local adaptativo usando
    imagens integrais pode extrair pixels de fronteira com sucesso quan
    do possuem muito ruído.
    
      O contorno extraído neste passo (1C por exemplo) é irregular e
    e pode apresentar alguns pixels trocados na borda devido a presen
    ça de ruído ao longo da fronteira. Obter uma aparência real do
    contorno do objeto requer algumas operações a mais. Isso pode ser
    feito suavizando o contorno extraído. A seção seguinte descreve 
    Descritores de Fourier em relação com suavização de contorno.
*/

