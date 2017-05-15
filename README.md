# AVForW

- Je me suis contentré principalement sur la communication entre la classe SearchManager qui controller l'API et ListHotelViewController qui présente les résultats de la recherche. L'objectif etant de minimiser les temps de chargement et d'intégrer de façon continu les résultats.

- Pour cela j'ai donc utiliser la classe SearchManager qui s'occupe de controller la position de l'utilisateur dans la liste et de faire des appels à l'API si besoin. Le controller observe les résultats et les ajoutes lorsque de nouveaux sont chargés.

- J'intègre les résultats de l'API avec deux structures : Weekend et Hotel. Les images sont téléchargés et stockés pour éviter de multiplier les téléchargements.'

- J'utilise le framework RxSwift qui est vraiment pratique travailler de façon asynchrone. Je l'utilise particulièrement pour gérer les appels à l'API et pour télécharger les photos.

- Le controller WeekendViewController présente simplement le weekend (je ne charge pas d'autre information mais je n'aurais aucun soucis à le srécupérer).
