---
title:  "Entrevistas en Diferido"
last_modified_at: 2026-04-13
tags:
  - dev
  - es
toc: false
toc_sticky: true
image: /assets/images/posts/2026-04-13-entrevistas-diferido.jpg
image_link: https://t.me/s/entrevistaendiferido
---

**Entrevista para el canal [Entrevistas en Diferido](https://t.me/s/entrevistaendiferido)**

> #EntrevistaJoseCastilloLema
> [@josecastillolema](https://t.me/josecastillolema)
> Empezamos nueva entrevista, esta semana tenemos tenemos a Jose Castillo Lema, trabaja en Red Hat, profesor, ponente y mucho mas, lo mejor es que se presente el mismo.
> Pero antes...
> ¿Cómo te encuentras?
> Y ahora.
> **¿te podrías presentar en unas palabras?**

¡Buenos días a todos!

Soy José, de Santiago de Compostela, aunque actualmente vivo en Madrid tras haber pasado más de 12 años en Brasil. Llevo 7 años en Red Hat, primero como consultor y arquitecto, y actualmente trabajo como ingeniero de software en el equipo de OpenShift Performance & Scale. También doy clase en la UC3M en el departamento de telemática.

¡Muchas gracias por la invitación [@JoseAJimenez](https://t.me/JoseAJimenez) !

> Para empezar, unas cuantas  preguntas cortas para conocerte mejor a ti  y a tu entorno tecnológico.
> **¿Qué ordenador utilizas habitualmente?**

Un Lenovo ThinkPad X1 P1 Gen 4.

> **¿Qué distribución de Linux usas?**

Fedora Atomic Sway.

> **¿Qué herramienta es imprescindible en todos tus equipos?**

Sin duda, el terminal. Más concretamente, mi flujo de trabajo alrededor: [https://github.com/josecastillolema/dotfiles](https://github.com/josecastillolema/dotfiles). Me permite ser rápido, reproducible y trabajar de la misma forma en cualquier máquina, ya sea local o remota.

> **¿Qué herramienta de Linux consideras que es más importante en el ecosistema de aplicaciones de Linux?**

No una herramienta en si pero la filosofía UNIX de "hacer una cosa bien y combinarlas" sigue siendo para mí uno de los mayores valores diferenciales de Linux: permiten componer soluciones simples en *pipelines* potentes, automatizar tareas y orquestar procesos complejos de forma muy eficiente.

> Pregunta fija que cambia en función del perfil del entrevistado, en tu caso me centro en el ámbito de Linux.
> Dentro de ese ámbito.
> **¿Qué añadirías?**

Potenciaría herramientas modernas de CLI con buenas interfaces (tipo `fzf`, `ripgrep`, `tmux`, etc.) como parte del *stack* base.

> **¿Qué modificarías?**

Revisaría la experiencia de usuario en muchas herramientas clásicas: siguen siendo potentes, pero a veces poco consistentes en *flags*, formatos de salida, etc.

> **¿Qué eliminarías?**

Intentaría simplificar la fragmentación actual: demasiadas formas de hacer lo mismo (gestores de paquetes, distros, *init systems*, etc.), a ser posible manteniendo la flexibilidad.

> **¿Qué dejarías igual?**

La filosofía Unix: herramientas pequeñas que hacen una cosa bien y se combinan mediante *pipes*, la capacidad de encadenar herramientas simples para construir soluciones complejas.

> Como usuario de Linux veras que hay una enorme ecosistema de distribuciones Linux que es motivo de mucho de debate porque algunos piensan en fragmentación y dividir los recursos, otros el libertad, posibilidad de elección.
> Por eso te pregunto...
> **¿Qué te parece el ecosistema de distribuciones de Linux?**

La fragmentación es el precio de la libertad que define a Linux y en general al ecosistema *open source*. Permite experimentar, innovar y adaptar el sistema a necesidades muy distintas, aunque también introduce cierta complejidad.

Creo que proyectos como [bootc](https://bootc.dev/), que permiten definir y personalizar el sistema operativo de forma declarativa (en este caso como si se tratase de un *container*) pueden ayudar a reducir la fragmentacion actual.

En cuanto al panorama actual de distribuciones, personalmente soy muy partidario de las distros inmutables. Llevo usando Fedora Atomic desde la versión 37 y no tengo intención de volver atrás, la posibilidad de hacer *roll backs* es fantástica.

> En EsLibre2026 estaras con dos charlas Ocaml vs Python, la segunda sobre Containerlab, me voy a centrar sobre la primera charla.
Ocaml es un lenguaje funcional, algo de lo que tengo muy poco conocimiento, por eso te pregunto...
> Imagina que he terminado la Ingeniería de Informática y tengo claro que quiero enfocarme en el desarrollo pero no se exactamente por que lenguaje enfocarme.
> **¿Porqué debería elegir Ocaml y en general los lenguajes funcionales?**

esLibre va a ser el 17 y 18 de Abril en Melide, os dejo [aquí](https://eslib.re/2026/es/horario/) el programa.

Sobre porqué estudiar lenguajes de programacion funcionales: el paradigma de programación funcional cada vez está más presente en los lenguajes mainstream: Python, Java, Golang, Rust, etc. Aprender conceptos como inmutabilidad, funciones puras, recursión, funciones de orden superior, etc. te hace un mejor programador independientemente del lenguaje que estes usando.

La charla que voy a dar se llama Ocaml vs Python: ventajas de lenguajes (verdaderamente) funcionales, os dejo [aquí](https://github.com/josecastillolema/talks/blob/main/2026-eslibre-ocaml/slides.pdf) las diapositivas por si os interesan.

> Hay una serie de pregunta sobre Linux que se pueden considerar como clásicas, te voy a realizar una de esas pregunta pero desde otro punto de vista.
> **¿Qué pasaría si Linux tuviera el 40% o mas de cuota de mercado en el escritorio?**

Pues aunque me encantaría que así fuera el caso (y para ello haría falta que los fabricantes se pusieran las pilas, o fuesen presionados a ponerselas), me parece más relevante que Linux continue siendo el estándar en el ámbito enterprise: *containers*, kubernetes, ahora AI *workloads*, etc.

Donde si me gustaría ver más adopción a nivel de escritorio es en las administraciones públicas, institutos, universidades, etc. Ahí creo que Linux tiene mucho sentido: por coste, por soberanía tecnológica y por la posibilidad de construir entornos más abiertos y controlables.

> Una parte muy importante y diferenciadora es la comunidad, porque en Linux es diferente a la comunidad que hay en Windows o MacOS, porque puede desarrollar/colaborar en los componentes del sistema operativo.
> Por eso te pregunto.
> **¿Qué te parece la comunidad de Linux?**

Pues soy sospechoso de opinar puesto que soy parte pero en general me parece una comunidad bastante razonable. Animo a que todo el mundo participe, reporte *issues*, colabore, etc. A veces cuando abrimos un incidente, aunque no podamos contribuir con el código en sí podemos ayudar de otras formas, testando el *fix*, ayudando con documentación, empaquetado, etc.

También es importante tener empatía hacia los mantenedores de cada proyecto, intentar entender otros puntos de vista, etc.

> Vas a participar en el evento de EsLibre 2026 y no se si has participado anteriormente en algún evento relacionado con el software libre y Linux.
> **¿Qué destacarías de estos eventos?**

He participado en varios eventos como FOSDEM, DevConf, OVSCONF o Red Hat Summit.
- FOSDEM destaca por la escala y por el increíble contenido técnico.
- Red Hat Summit es más corporativo, pero muy interesante para entender hacia dónde va la industria.
- En el caso de OVSCONF por la profundidad técnica en *networking*.
- Aun así, mi favorito es DevConf en Brno: tiene un equilibrio muy bueno entre nivel técnico alto y un ambiente cercano y colaborativo. Además, Brno en junio + 🍺.

> El Viernes es el último día con este formato de preguntas, el fin de semana cambia un poco, finalizamos  con dos preguntas algo diferentes.
> La primera.
> Si vivieras en la Edad Media.
> **¿A qué se dedicaría José?**

Pues habría intentado acabar en alguna universidad de la época, Salamanca, París o Oxford.

> La segunda pregunta...
> **¿Qué pasaría si...?**
> Completa la pregunta para el próximo entrevistado.

¿Qué pasaría si la tecnología dejara de avanzar durante los próximos 10 años?

> Un anterior entrevistado completo la pregunta y te toca responderla.
> **¿Qué pasaría si de repente, retrocedemos 20 años al pasado?**

A nivel tecnológico perderíamos muchas de las comodidades que hoy damos por sentado (cloud, contenedores, tooling moderno, etc.) y volveríamos a entornos mucho más manuales y heterogéneos.

Nos daríamos cuenta de cuánto hemos avanzado … y de qué cosas realmente merecen la pena y cuáles son solo complejidad añadida.

> El fin de semana cambia un poco el formato de la entrevista.
> El sábado  siguen siendo dos preguntas, pero  algo diferentes.
> La primera.
> **¿Qué te hubiera gustado que te preguntase? Debes responder a tu propia pregunta.**

¿Qué error común ves en cómo trabajamos hoy en día?

La tendencia a añadir capas de complejidad demasiado pronto. Muchas veces adoptamos herramientas o *frameworks* sin entender bien el problema que estamos intentando resolver. Es fundamental simplificar cuando sea posible.

> La segunda pregunta, es que te gustaría que le preguntase a una persona con un perfil similar al tuyo.
> La pregunta sería...
> **¿Qué le hubieras preguntado a un usuario de Linux?** En este caso no debes responder a la pregunta.

¿Qué opinas de las distros inmutables y cómo encajan en tu forma de trabajar?

> El Domingo,  es el último día de la entrevista, será el momento de la despedida y para decir  tus métodos de contacto, también para promocionar cualquier  proyecto que quieras.
> Por último me gustaría que me recomiendes, a una persona que creas que este dispuesto a participar en una futura entrevista.
> Gracias por participar en la entrevista, ha sido un placer y espero que te haya resultado entretenida.
> Hasta la próxima, un saludo.

Muchas gracias a todos y por la invitación [@JoseAJimenez](https://t.me/JoseAJimenez)!

Os dejo mis contactos:
- [LinkedIn](https://www.linkedin.com/in/jose-castillo-lema)
- [Blog](https://josecastillolema.github.io/)
- [GitHub](https://github.com/josecastillolema)

Para futuras entrevistas os recomiendo a Diego Beltrán, que está haciendo un trabajo muy interesante con computación cuántica.
